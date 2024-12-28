class LogsController < ApplicationController
  def index
    @logs = Log.all
  end

  def new
    @log = Log.new
  end
  
  def create
    uploaded_file = params[:file]
    excel_file_path = Rails.root.join("public/uploads/#{uploaded_file.original_filename}")
    File.open(excel_file_path, 'w+b') do |file|
      file.write(uploaded_file.read)
    end
  end
  
  def show
    # OSによってログファイルのパスを分ける
    log_file_path = case RbConfig::CONFIG['host_os']
    when /darwin/  # macOS
      '/Users/minorisugimura/.wine/drive_c/koshien2024/log/player1.log'
    when /mswin|mingw|cygwin/  # Windows
      'C:/koshien2024/log/player1.log'
    else
      raise "サポートされていないOSです"
    end

    if File.exist?(log_file_path)
      @logs = File.readlines(log_file_path)
                  .map { |line| line.gsub(/.*getMapAreaを実行します 引数=\[(\d+), (\d+)\].*/) { "getMapArea([#{Regexp.last_match(1)}, #{Regexp.last_match(2)}])"} }
                  .map { |line| line.gsub(/.*moveToを実行します 引数=\[(\d+), (\d+)\].*/) { "moveTo([#{Regexp.last_match(1)}, #{Regexp.last_match(2)}])"} }
                  .map { |line| line.gsub(/.*setDynamiteを実行します 引数=\[(\d+), (\d+)\].*/) { "setDynamite([#{Regexp.last_match(1)}, #{Regexp.last_match(2)}])"} }
                  .split { |line| line.include?('プレイヤー名を設定します') }[1]
                  .split { |line| line.include?('turnOver') }
                  # .map(&:strip) # 各行の前後の空白を削除する場合
      @logs.each_with_index do |log, index|
        log.each do |l|
          clusters = l.scan(/Clusters\(n=\d+\) = (\[\[\[.*?\]\]\])/)
          centroids = l.scan(/Centroids: (\[\[.*?\]\])/)
          mse = l.scan(/MSE = ([\d.]+)/)

          # 変数を出力
          if clusters.present?
            puts "Clusters(turn: #{index + 1}): #{clusters}"
          end
          if centroids.present?
            puts "Centroids(turn: #{index + 1}): #{centroids}"
          end
          if mse.present?
            puts "MSE(turn: #{index + 1}): #{mse}"
          end
        end
      end
    else
      render json: { error: 'ログファイルが見つかりません。' }, status: :not_found
    end
  end

  private

  #CORSを許可する場合（必要に応じて）
  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = 'http://localhost:3000'
    headers['Access-Control-Allow-Methods'] = 'GET'
  end
end
