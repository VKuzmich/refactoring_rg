# frozen_string_literal: true

module Database
  def write_to_file(data)
    File.open(@account.file_path, 'w') { |f| f.write data.to_yaml }
  end

  def accounts
    return [] unless File.exist?(PATH)

    YAML.load_file(PATH)
  end
end
