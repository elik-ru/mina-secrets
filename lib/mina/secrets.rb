set :secrets_files, -> { ["config/master.key", "config/credentials/#{fetch(:rails_env)}.key"] }

desc "Copy secrets files to the server."
task :'secrets:upload' do
  comment "Copying secrets files"
  fetch(:secrets_files).each do |file|
    if File.exist?(file)
      command "[ ! -f  #{fetch(:shared_path)}/#{file} ] && echo -n '#{File.open(file).read}' > #{fetch(:shared_path)}/#{file} || echo 'Skiping existing file #{file}'"
    else
      command "echo 'Local file #{file} does not exist'"
    end
  end
end

desc "Copy secrets files to the server. Overwrite existing files."
task :'secrets:upload:force' do
  comment "Copying secrets files"
  fetch(:secrets_files).each do |file|
    if File.exist?(file)
      command "[ -f  #{fetch(:shared_path)}/#{file} ] && echo 'Overwriting existing file #{file}' ; echo -n '#{File.open(file).read}' > #{fetch(:shared_path)}/#{file}"
    else
      command "echo 'Local file #{file} does not exist'"
    end
  end
end


desc "Download secrets files from the server."
task :'secrets:download' do
  comment "Downloading secrets files"
  run(:local) do
    fetch(:secrets_files).each do |file|
      if File.exist?(file)
        comment "Skiping existing file #{file}"
      else
        command "scp #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/#{file} #{file} 2>/dev/null || echo 'Remote file #{file} does not exist'"
      end
    end
  end
end

desc "Download secrets files from the server. Overwrite existing local files."
task :'secrets:download:force' do
  comment "Downloading secrets files"
  run(:local) do
    fetch(:secrets_files).each do |file|
      if File.exist?(file)
        comment "Overwriting existing file #{file}"
      end
      command "scp #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/#{file} #{file} 2>/dev/null || echo 'Remote file #{file} does not exist'"
    end
  end
end
