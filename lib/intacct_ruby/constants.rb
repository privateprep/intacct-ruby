module IntacctRuby::Constants

  DEFINITIONS_PATH = 'app/lib/intacct_ruby/legacy_endpoints'

  DEFINITIONS = {
    get: File.read("#{DEFINITIONS_PATH}/get.json"),
    get_list: File.read("#{DEFINITIONS_PATH}/get_list.json"),
    create_supdoc: File.read("#{DEFINITIONS_PATH}/create_supdoc.json"),
    update_supdoc: File.read("#{DEFINITIONS_PATH}/create_supdoc.json"),
    create_supdocfolder:   File.read("#{DEFINITIONS_PATH}/create_supdocfolder.json"),
    update_supdocfolder:   File.read("#{DEFINITIONS_PATH}/create_supdocfolder.json"),
    record_cctransaction:  File.read("#{DEFINITIONS_PATH}/record_cctransaction.json"),
    update_cctransaction:  File.read("#{DEFINITIONS_PATH}/update_cctransaction.json"),
    reverse_cctransaction: File.read("#{DEFINITIONS_PATH}/reverse_cctransaction.json"),
  }

  LEGACY = {
    get: JSON.parse(DEFINITIONS[:get]).deep_symbolize_keys,
    get_list: JSON.parse(DEFINITIONS[:get_list]).deep_symbolize_keys,
    create_supdoc: JSON.parse(DEFINITIONS[:create_supdoc]).deep_symbolize_keys,
    update_supdoc: JSON.parse(DEFINITIONS[:update_supdoc]).deep_symbolize_keys,
    create_supdocfolder:   JSON.parse(DEFINITIONS[:create_supdocfolder]).deep_symbolize_keys,
    update_supdocfolder:   JSON.parse(DEFINITIONS[:update_supdocfolder]).deep_symbolize_keys,
    record_cctransaction:  JSON.parse(DEFINITIONS[:record_cctransaction]).deep_symbolize_keys,
    update_cctransaction:  JSON.parse(DEFINITIONS[:update_cctransaction]).deep_symbolize_keys,
    reverse_cctransaction: JSON.parse(DEFINITIONS[:reverse_cctransaction]).deep_symbolize_keys,
  }
end
