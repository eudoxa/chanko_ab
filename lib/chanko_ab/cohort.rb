class Cohort
  attr_accessor :name, :attributes
  private attr_accessor :split_test
  def initialize(name, attributes, split_test)
    self.name = name
    self.attributes = attributes
    self.split_test = split_test
  end

  def log_key(template_name)
    template = self.split_test.log_templates[template_name]
    template.gsub('[name]', name)
  end

  def log(template_name, attributes = {})
    ChankoAb.log(log_key(template_name), attributes)
  end
end
