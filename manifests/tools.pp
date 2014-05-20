class csrterc::tools {
  class { 'csrterc::tools::editors': }
  -> class { 'csrterc::tools::vcs': }
  -> class { 'csrterc::tools::misc': }
}

