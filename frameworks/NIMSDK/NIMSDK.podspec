Pod::Spec.new do |spec| 

 spec.name = 'NIMSDK'     
 spec.version = '7.2.5'
 spec.summary = 'Netease IM SDK'
 spec.homepage = 'https://netease.im'
 spec.license = { :'type' => 'Copyright', :'text' => ' Copyright 2020 Netease '}   
 spec.authors = 'Netease IM Team'  
 spec.source = { :http => 'http://yx-web.nos.netease.com/package/1564643192/NIM_iOS_SDK_v6.7.0.zip'}  
 spec.platform = :ios, '8.0'  
 spec.vendored_frameworks = 'NIMSDK.framework'
 spec.frameworks = 'SystemConfiguration', 'AVFoundation', 'CoreTelephony', 'AudioToolbox', 'CoreMedia' , 'VideoToolbox'  
 spec.libraries = 'sqlite3.0', 'z', 'c++'

end   

