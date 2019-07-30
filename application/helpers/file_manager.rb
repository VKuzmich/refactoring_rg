# frozen_string_literal: true

module FileManager
  def write_to_file(data)
    File.open(@account.file_path, 'w') { |f| f.write data.to_yaml }
  end
end
