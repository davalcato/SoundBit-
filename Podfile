# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SoundBit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SoundBit
  pod 'AWSUserPoolsSignIn'
  pod 'AWSAuthUI'
  pod 'AWSFacebookSignIn'
  pod ‘GoogleSignIn’
  pod 'SDWebImage'
  pod 'Appirater'
  pod 'Firebase/Analytics'  
  pod 'AWSMobileClient'




  target 'SoundBitTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SoundBitUITests' do
    # Pods for testing  
   end

  end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end

