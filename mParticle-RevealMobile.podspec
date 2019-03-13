Pod::Spec.new do |s|
    s.name             = "mParticle-RevealMobile"
    s.version          = "7.9.0"
    s.summary          = "Reveal Mobile integration for mParticle"

    s.description      = <<-DESC
                       This is the Reveal Mobile integration for mParticle.
                       DESC

    s.homepage         = "https://www.mparticle.com"
    s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author           = { "mParticle" => "support@mparticle.com", "Reveal Mobile" => "support@revealmobile.com" }
    s.source           = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-revealmobile.git", :tag => s.version.to_s }

    s.ios.deployment_target = "8.0"
    s.ios.source_files      = 'mParticle-RevealMobile/*.{h,m,mm}'
    s.ios.dependency 'mParticle-Apple-SDK/mParticle', '~> 7.9.0'
    s.ios.dependency 'Reveal', '~> 1.3'
    s.source_files = 'mParticle-RevealMobile/**/*'
    s.requires_arc = true
end
