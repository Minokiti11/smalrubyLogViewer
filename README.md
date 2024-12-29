# README

### Usage
```ruby:logs_controller.rb
  def show
    # OSによってログファイルのパスを分ける
    log_file_path = case RbConfig::CONFIG['host_os']
    when /darwin/  # macOS
      '/Users/minorisugimura/.wine/drive_c/koshien2024/log/player1.log' #ログファイルの絶対パス
    when /mswin|mingw|cygwin/  # Windows
      'C:/koshien2024/log/player1.log' #ログファイルの絶対パス
    else
      raise "サポートされていないOSです"
    end
    #省略
  end


```
