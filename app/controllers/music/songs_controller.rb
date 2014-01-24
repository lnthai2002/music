#require 'lib/music/tag_info.rb'

module Music
  class SongsController < AuthorizableController
    before_filter :check_drb_server, only: [:streamfile, :scan, :load_tags, :write_tag]
    #GET /song/streamfile
    def streamfile
      remoteFs = DRbObject.new(nil, "druby://#{params['host']}:54321") #RFM::Handler::BinaryFile
      file = remoteFs.get_audio_file(params['filename'], @user.drb_server.security_key)
      name = File.basename(params['filename'])
      send_data(file, type: 'audio/mpeg', filename: "#{name}", disposition: 'inline')
    end

    #GET /songs/scan
    def scan
      @scan_task = ScanTask.new
    end

    #GET /songs/load_tags
    def load_tags
      scan_task = ScanTask.new(scan_task_params)
      scan_task.drb_server = @user.drb_server

      @write_task = WriteTask.new
      begin
        @write_task.articles = scan_task.execute
        render 'write'
      rescue
        @scan_task = scan_task
        render 'scan'
      end
      
    end

    #POST /songs/write_tags
    def write_tags
      @write_task = WriteTask.new(write_task_params)
      @write_task .drb_server = @user.drb_server
      begin
        @results = @write_task.execute
      rescue
        render 'load_tags'
      end
    end

    # GET /songs
    # GET /songs.json
    def index
      @songs = []
      @scan_task = ScanTask.new
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @songs }
      end
    end

    # GET /songs/1
    # GET /songs/1.json
    def show
      @song = Song.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @song }
        format.mp3 {
          file = File.read(@song.location)
          send_data(file, :type => "audio/mpeg", :filename => "#{@song.id}.mp3", :disposition => "inline")
        }
      end
    end

    # GET /songs/new
    # GET /songs/new.json
    def new
      @song = Song.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @song }
      end
    end

    # GET /songs/1/edit
    def edit
      @song = Song.find(params[:id])
    end

    # POST /songs
    # POST /songs.json
    def create
      @song = Song.new(params[:song])

      respond_to do |format|
        if @song.save
          format.html { redirect_to @song, notice: 'Song was successfully created.' }
          format.json { render json: @song, status: :created, location: @song }
        else
          format.html { render action: "new" }
          format.json { render json: @song.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /songs/1
    # PUT /songs/1.json
    def update
      @song = Song.find(params[:id])

      params[:song].each do |tag, value|
        if TagInfo::USEFULL_TAGS.include?(tag)#tag on file is a useful tag
        @song[tag] = value #update the useful tag in DB
        end
      end
      respond_to do |format|
        begin
          Song.transaction do #update both file and DB or neither
            @song.update_tags_on_file(params[:song])
            @song.save!
          end
          format.html { redirect_to @song, notice: 'Song was successfully updated.' }
          format.json { head :ok }
        rescue Exception=>e
          format.html { render action: "edit" }
          format.json { render json: @song.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /songs/1
    # DELETE /songs/1.json
    def destroy
      @song = Song.find(params[:id])
      @song.destroy

      respond_to do |format|
        format.html { redirect_to songs_url }
        format.json { head :ok }
      end
    end

    def search
      if params[:search]
        conds = []
        if not params[:search][:title].blank?
          conds << {'title'=>params[:search][:title]}
        end
        if not params[:search][:artist].blank?
          conds << {'artist'=>params[:search][:artist]}
        end
        if not params[:search][:album].blank?
          conds << {'album'=>params[:search][:album]}
        end
        if not params[:search][:genre].blank?
          conds << {'genre'=>params[:search][:genre]}
        end
        conds.each do |column, filter|
          filter = filter.gsub(' ', '%')
        end
        @results = Song.paginate(:all, :conditions=>conds, :page=>page)
      end
    end
=begin
   def download
      id = File.basename(params[:id],File.extname(params[:id]))
      @song = Song.find(id)
      file = File.read(@song.location)
      send_data(file, :type => "audio/mpeg", :filename => "#{@song.id}.mp3", :disposition => "inline")
    end
=end
    protected

    def check_drb_server
      if @user.drb_server.blank?
        redirect_to new_drb_server_path
      end
    end

    private

    def scan_task_params
      params.require('scan_task').permit('host', 'security_key', 'folder', 'recursive')
    end

    def write_task_params
      params.require('write_task')
            .permit('host',
                    'security_key',
                    articles_attributes: ['file', 'timestamp', 'title',
                                          'artist','album', 'year','track',
                                          'genre', 'comment', 'length', 'apic'])
    end
  end
end
