namespace :k8s do
  desc 'Generate ingress YAML from ERB'
  task ingress: :environment do
    generate('ingress')
  end

  desc 'Generate cert-manager issuer YAML from ERB'
  task ingress: :environment do
    generate('issuer')
  end

  def generate(name)
    path = Rails.root.join('config', 'kubernetes', "#{name}.yml.erb")
    template = ERB.new(path.read)

    puts template.result(binding)
  end
end
