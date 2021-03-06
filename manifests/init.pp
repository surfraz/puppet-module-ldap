define ldap (
  $ensure                = '',
  $server_nodes          = undef,
  $client_nodes          = undef,
  $utils_nodes           = undef,
  $user                  = '',
  $group                 = '',
  $base_dn               = undef,
  $admin_user            = undef,
  $password              = '',
  $protocols             = '',
  $protocol              = '',
  $ldap_version          = '',
  $server_addr           = '',
  $port                  = '',
  $ssl_port              = '',
  $search_timelimit      = '',
  $bind_timelimit        = '',
  $idle_timelimit        = '',
  $misc_dir              = '',
  $ldap_conf_dir         = '',
  $directory_base        = '',
  $directories           = undef,
  $args_file             = '',
  $log_level             = '',
  $pid_file              = '',
  $tool_threads          = '',
  $ssl_verify_certs      = '',
  $ssl_cacert_file       = '',
  $ssl_cacert_path       = '',
  $ssl_cert_file         = '',
  $ssl_key_file          = '',
  $ssl_cipher_suite      = '',
  $ssl_rand_file         = '',
  $ssl_ephemeral_file    = '',
  $ssl_minimum           = '',
  $ssl_mode              = '',
  $sasl_minssf           = '',
  $sasl_maxssf           = '',
  $ssl_cert_country      = '',
  $ssl_cert_state        = '',
  $ssl_cert_city         = '',
  $ssl_cert_organization = '',
  $ssl_cert_department   = '',
  $ssl_cert_domain       = '',
  $ssl_cert_email        = '',
  $bind_policy           = '',
  $pam_min_uid           = '',
  $pam_max_uid           = '',
  $exec_path             = ''
) {
  # Check to see if we have been called previously by utilizing as dummy
  # resource.
  if( defined( Ldap::Dummy[ 'ldap' ] ) ) {
    fail( 'The "ldap" define has already been called previously in your manifest!' )
  }
  ldap::dummy{ 'ldap': }

  # Load in all of our configs and then play around with some variables..
  include ldap::server::config
  include ldap::client::config
  include ldap::utils::config

  $config_server_nodes = $server_nodes ? { default => $server_nodes, '' => $ldap::server::config::server_nodes }
  $config_client_nodes = $client_nodes ? { default => $client_nodes, '' => $ldap::client::config::client_nodes }
  $config_utils_nodes  = $utils_nodes  ? { default => $utils_nodes,  '' => $ldap::utils::config::utils_nodes   }
  $config_admin_user   = $admin_user   ? { default => $admin_user,   '' => $ldap::config::admin_user           }

  if( ! $base_dn and ! $directories ) {
    $config_base_dn     = $ldap::config::base_dn
    $config_directories = $ldap::server::config::directories
  }
  if( ! $base_dn ) {
    $config_base_dn     = inline_template( '<%= directories[0] %>' )
    $config_directories = $directories
  }
  if( ! $directories ) {
    $config_base_dn     = $base_dn
    $config_directories = [ $base_dn ]
  }
  if( ! $config_base_dn     ) { $config_base_dn     = $base_dn     }
  if( ! $config_directories ) { $config_directories = $directories }

  # First, check to see if the current node is supposed to be a server node.
  $is_server_node = inline_template( '<%= config_server_nodes.flatten.include?( fqdn.downcase ) %>' )
  if( $is_server_node == 'true' ) {

    ldap::server{ 'ldap::server':
      server_nodes          => $config_server_nodes,
      client_nodes          => $config_client_nodes,
      utils_nodes           => $config_utils_nodes,
      admin_user            => $config_admin_user,
      ensure                => $ensure                ? { default => $ensure,                '' => $ldap::server::config::ensure                },
      user                  => $user                  ? { default => $user,                  '' => $ldap::server::config::user                  },
      group                 => $group                 ? { default => $group,                 '' => $ldap::server::config::group                 },
      base_dn               => $config_base_dn,
      password              => $password              ? { default => $password,              '' => $ldap::server::config::password              },
      protocols             => $protocols             ? { default => $protocols,             '' => $ldap::server::config::protocols             },
      protocol              => $protocol              ? { default => $protocol,              '' => $ldap::server::config::protocol              },
      ldap_version          => $ldap_version          ? { default => $ldap_version,          '' => $ldap::server::config::ldap_version          },
      server_addr           => $server_addr           ? { default => $server_addr,           '' => $ldap::server::config::server_addr           },
      port                  => $port                  ? { default => $port,                  '' => $ldap::server::config::port                  },
      ssl_port              => $ssl_port              ? { default => $ssl_port,              '' => $ldap::server::config::ssl_port              },
      search_timelimit      => $search_timelimit      ? { default => $search_timelimit,      '' => $ldap::server::config::search_timelimit      },
      bind_timelimit        => $bind_timelimit        ? { default => $bind_timelimit,        '' => $ldap::server::config::bind_timelimit        },
      idle_timelimit        => $idle_timelimit        ? { default => $idle_timelimit,        '' => $ldap::server::config::idle_timelimit        },
      misc_dir              => $misc_dir              ? { default => $misc_dir,              '' => $ldap::server::config::misc_dir              },
      ldap_conf_dir         => $ldap_conf_dir         ? { default => $ldap_conf_dir,         '' => $ldap::server::config::ldap_conf_dir         },
      directory_base        => $directory_base        ? { default => $directory_base,        '' => $ldap::server::config::directory_base        },
      directories           => $config_directories,
      args_file             => $args_file             ? { default => $args_file,             '' => $ldap::server::config::args_file             },
      log_level             => $log_level             ? { default => $log_level,             '' => $ldap::server::config::log_level             },
      pid_file              => $pid_file              ? { default => $pid_file,              '' => $ldap::server::config::pid_file              },
      tool_threads          => $tool_threads          ? { default => $tool_threads,          '' => $ldap::server::config::tool_threads          },
      ssl_verify_certs      => $ssl_verify_certs      ? { default => $ssl_verify_certs,      '' => $ldap::server::config::ssl_verify_certs      },
      ssl_cacert_file       => $ssl_cacert_file       ? { default => $ssl_cacert_file,       '' => $ldap::server::config::ssl_cacert_file       },
      ssl_cacert_path       => $ssl_cacert_path       ? { default => $ssl_cacert_path,       '' => $ldap::server::config::ssl_cacert_path       },
      ssl_cert_file         => $ssl_cert_file         ? { default => $ssl_cert_file,         '' => $ldap::server::config::ssl_cert_file         },
      ssl_key_file          => $ssl_key_file          ? { default => $ssl_key_file,          '' => $ldap::server::config::ssl_key_file          },
      ssl_cipher_suite      => $ssl_cipher_suite      ? { default => $ssl_cipher_suite,      '' => $ldap::server::config::ssl_cipher_suite      },
      ssl_rand_file         => $ssl_rand_file         ? { default => $ssl_rand_file,         '' => $ldap::server::config::ssl_rand_file         },
      ssl_ephemeral_file    => $ssl_ephemeral_file    ? { default => $ssl_ephemeral_file,    '' => $ldap::server::config::ssl_ephemeral_file    },
      ssl_minimum           => $ssl_minimum           ? { default => $ssl_minimum,           '' => $ldap::server::config::ssl_minimum           },
      ssl_mode              => $ssl_mode              ? { default => $ssl_mode,              '' => $ldap::server::config::ssl_mode              },
      sasl_minssf           => $sasl_minssf           ? { default => $sasl_minssf,           '' => $ldap::server::config::sasl_minssf           },
      sasl_maxssf           => $sasl_maxssf           ? { default => $sasl_maxssf,           '' => $ldap::server::config::sasl_maxssf           },
      ssl_cert_country      => $ssl_cert_country      ? { default => $ssl_cert_country,      '' => $ldap::server::config::ssl_cert_country      },
      ssl_cert_state        => $ssl_cert_state        ? { default => $ssl_cert_state,        '' => $ldap::server::config::ssl_cert_state        },
      ssl_cert_city         => $ssl_cert_city         ? { default => $ssl_cert_city,         '' => $ldap::server::config::ssl_cert_city         },
      ssl_cert_organization => $ssl_cert_organization ? { default => $ssl_cert_organization, '' => $ldap::server::config::ssl_cert_organization },
      ssl_cert_department   => $ssl_cert_department   ? { default => $ssl_cert_department,   '' => $ldap::server::config::ssl_cert_department   },
      ssl_cert_domain       => $ssl_cert_domain       ? { default => $ssl_cert_domain,       '' => $ldap::server::config::ssl_cert_domain       },
      ssl_cert_email        => $ssl_cert_email        ? { default => $ssl_cert_email,        '' => $ldap::server::config::ssl_cert_email        },
      bind_policy           => $bind_policy           ? { default => $bind_policy,           '' => $ldap::server::config::bind_policy           },
      pam_min_uid           => $pam_min_uid           ? { default => $pam_min_uid,           '' => $ldap::server::config::pam_min_uid           },
      pam_max_uid           => $pam_max_uid           ? { default => $pam_max_uid,           '' => $ldap::server::config::pam_max_uid           },
      exec_path             => $exec_path             ? { default => $exec_path,             '' => $ldap::server::config::exec_path             },
    }
  }
  
  $is_client_node = inline_template( '<%= config_client_nodes.flatten.include?( fqdn.downcase ) %>' )
  if( $is_client_node == 'true' ) {
    ldap::client{ 'ldap::client':
      server_nodes          => $config_server_nodes,
      client_nodes          => $config_client_nodes,
      utils_nodes           => $config_utils_nodes,
      admin_user            => $config_admin_user,
      ensure                => $ensure                ? { default => $ensure,                '' => $ldap::client::config::ensure                },
      user                  => $user                  ? { default => $user,                  '' => $ldap::client::config::user                  },
      group                 => $group                 ? { default => $group,                 '' => $ldap::client::config::group                 },
      base_dn               => $config_base_dn,               
      password              => $password              ? { default => $password,              '' => $ldap::client::config::password              },
      protocols             => $protocols             ? { default => $protocols,             '' => $ldap::client::config::protocols             },
      protocol              => $protocol              ? { default => $protocol,              '' => $ldap::client::config::protocol              },
      ldap_version          => $ldap_version          ? { default => $ldap_version,          '' => $ldap::client::config::ldap_version          },
      server_addr           => $server_addr           ? { default => $server_addr,           '' => $ldap::client::config::server_addr           },
      port                  => $port                  ? { default => $port,                  '' => $ldap::client::config::port                  },
      ssl_port              => $ssl_port              ? { default => $ssl_port,              '' => $ldap::client::config::ssl_port              },
      search_timelimit      => $search_timelimit      ? { default => $search_timelimit,      '' => $ldap::client::config::search_timelimit      },
      bind_timelimit        => $bind_timelimit        ? { default => $bind_timelimit,        '' => $ldap::client::config::bind_timelimit        },
      idle_timelimit        => $idle_timelimit        ? { default => $idle_timelimit,        '' => $ldap::client::config::idle_timelimit        },
      misc_dir              => $misc_dir              ? { default => $misc_dir,              '' => $ldap::client::config::misc_dir              },
      ldap_conf_dir         => $ldap_conf_dir         ? { default => $ldap_conf_dir,         '' => $ldap::client::config::ldap_conf_dir         },
      directory_base        => $directory_base        ? { default => $directory_base,        '' => $ldap::client::config::directory_base        },
      directories           => $config_directories,
      args_file             => $args_file             ? { default => $args_file,             '' => $ldap::client::config::args_file             },
      log_level             => $log_level             ? { default => $log_level,             '' => $ldap::client::config::log_level             },
      pid_file              => $pid_file              ? { default => $pid_file,              '' => $ldap::client::config::pid_file              },
      tool_threads          => $tool_threads          ? { default => $tool_threads,          '' => $ldap::client::config::tool_threads          },
      ssl_verify_certs      => $ssl_verify_certs      ? { default => $ssl_verify_certs,      '' => $ldap::client::config::ssl_verify_certs      },
      ssl_cacert_file       => $ssl_cacert_file       ? { default => $ssl_cacert_file,       '' => $ldap::client::config::ssl_cacert_file       },
      ssl_cacert_path       => $ssl_cacert_path       ? { default => $ssl_cacert_path,       '' => $ldap::client::config::ssl_cacert_path       },
      ssl_cert_file         => $ssl_cert_file         ? { default => $ssl_cert_file,         '' => $ldap::client::config::ssl_cert_file         },
      ssl_key_file          => $ssl_key_file          ? { default => $ssl_key_file,          '' => $ldap::client::config::ssl_key_file          },
      ssl_cipher_suite      => $ssl_cipher_suite      ? { default => $ssl_cipher_suite,      '' => $ldap::client::config::ssl_cipher_suite      },
      ssl_rand_file         => $ssl_rand_file         ? { default => $ssl_rand_file,         '' => $ldap::client::config::ssl_rand_file         },
      ssl_ephemeral_file    => $ssl_ephemeral_file    ? { default => $ssl_ephemeral_file,    '' => $ldap::client::config::ssl_ephemeral_file    },
      ssl_minimum           => $ssl_minimum           ? { default => $ssl_minimum,           '' => $ldap::client::config::ssl_minimum           },
      ssl_mode              => $ssl_mode              ? { default => $ssl_mode,              '' => $ldap::client::config::ssl_mode              },
      sasl_minssf           => $sasl_minssf           ? { default => $sasl_minssf,           '' => $ldap::client::config::sasl_minssf           },
      sasl_maxssf           => $sasl_maxssf           ? { default => $sasl_maxssf,           '' => $ldap::client::config::sasl_maxssf           },
      ssl_cert_country      => $ssl_cert_country      ? { default => $ssl_cert_country,      '' => $ldap::client::config::ssl_cert_country      },
      ssl_cert_state        => $ssl_cert_state        ? { default => $ssl_cert_state,        '' => $ldap::client::config::ssl_cert_state        },
      ssl_cert_city         => $ssl_cert_city         ? { default => $ssl_cert_city,         '' => $ldap::client::config::ssl_cert_city         },
      ssl_cert_organization => $ssl_cert_organization ? { default => $ssl_cert_organization, '' => $ldap::client::config::ssl_cert_organization },
      ssl_cert_department   => $ssl_cert_department   ? { default => $ssl_cert_department,   '' => $ldap::client::config::ssl_cert_department   },
      ssl_cert_domain       => $ssl_cert_domain       ? { default => $ssl_cert_domain,       '' => $ldap::client::config::ssl_cert_domain       },
      ssl_cert_email        => $ssl_cert_email        ? { default => $ssl_cert_email,        '' => $ldap::client::config::ssl_cert_email        },
      bind_policy           => $bind_policy           ? { default => $bind_policy,           '' => $ldap::client::config::bind_policy           },
      pam_min_uid           => $pam_min_uid           ? { default => $pam_min_uid,           '' => $ldap::client::config::pam_min_uid           },
      pam_max_uid           => $pam_max_uid           ? { default => $pam_max_uid,           '' => $ldap::client::config::pam_max_uid           },
      exec_path             => $exec_path             ? { default => $exec_path,             '' => $ldap::client::config::exec_path             },
    }
  }

  $is_utils_node = inline_template( '<%= config_utils_nodes.flatten.include?( fqdn.downcase ) %>' )
  if( $is_utils_node == 'true' and ! defined( Ldap::Utils[ 'ldap::utils' ] ) ) {
    ldap::utils{ 'ldap::utils':
      server_nodes          => $config_server_nodes,
      client_nodes          => $config_client_nodes,
      utils_nodes           => $config_utils_nodes,
      admin_user            => $config_admin_user,
      ensure                => $ensure                ? { default => $ensure,                '' => $ldap::utils::config::ensure                },
      user                  => $user                  ? { default => $user,                  '' => $ldap::utils::config::user                  },
      group                 => $group                 ? { default => $group,                 '' => $ldap::utils::config::group                 },
      base_dn               => $config_base_dn,               
      password              => $password              ? { default => $password,              '' => $ldap::utils::config::password              },
      protocols             => $protocols             ? { default => $protocols,             '' => $ldap::utils::config::protocols             },
      protocol              => $protocol              ? { default => $protocol,              '' => $ldap::utils::config::protocol              },
      ldap_version          => $ldap_version          ? { default => $ldap_version,          '' => $ldap::utils::config::ldap_version          },
      server_addr           => $server_addr           ? { default => $server_addr,           '' => $ldap::utils::config::server_addr           },
      port                  => $port                  ? { default => $port,                  '' => $ldap::utils::config::port                  },
      ssl_port              => $ssl_port              ? { default => $ssl_port,              '' => $ldap::utils::config::ssl_port              },
      search_timelimit      => $search_timelimit      ? { default => $search_timelimit,      '' => $ldap::utils::config::search_timelimit      },
      bind_timelimit        => $bind_timelimit        ? { default => $bind_timelimit,        '' => $ldap::utils::config::bind_timelimit        },
      idle_timelimit        => $idle_timelimit        ? { default => $idle_timelimit,        '' => $ldap::utils::config::idle_timelimit        },
      misc_dir              => $misc_dir              ? { default => $misc_dir,              '' => $ldap::utils::config::misc_dir              },
      ldap_conf_dir         => $ldap_conf_dir         ? { default => $ldap_conf_dir,         '' => $ldap::utils::config::ldap_conf_dir         },
      directory_base        => $directory_base        ? { default => $directory_base,        '' => $ldap::utils::config::directory_base        },
      directories           => $config_directories,
      args_file             => $args_file             ? { default => $args_file,             '' => $ldap::utils::config::args_file             },
      log_level             => $log_level             ? { default => $log_level,             '' => $ldap::utils::config::log_level             },
      pid_file              => $pid_file              ? { default => $pid_file,              '' => $ldap::utils::config::pid_file              },
      tool_threads          => $tool_threads          ? { default => $tool_threads,          '' => $ldap::utils::config::tool_threads          },
      ssl_verify_certs      => $ssl_verify_certs      ? { default => $ssl_verify_certs,      '' => $ldap::utils::config::ssl_verify_certs      },
      ssl_cacert_file       => $ssl_cacert_file       ? { default => $ssl_cacert_file,       '' => $ldap::utils::config::ssl_cacert_file       },
      ssl_cacert_path       => $ssl_cacert_path       ? { default => $ssl_cacert_path,       '' => $ldap::utils::config::ssl_cacert_path       },
      ssl_cert_file         => $ssl_cert_file         ? { default => $ssl_cert_file,         '' => $ldap::utils::config::ssl_cert_file         },
      ssl_key_file          => $ssl_key_file          ? { default => $ssl_key_file,          '' => $ldap::utils::config::ssl_key_file          },
      ssl_cipher_suite      => $ssl_cipher_suite      ? { default => $ssl_cipher_suite,      '' => $ldap::utils::config::ssl_cipher_suite      },
      ssl_rand_file         => $ssl_rand_file         ? { default => $ssl_rand_file,         '' => $ldap::utils::config::ssl_rand_file         },
      ssl_ephemeral_file    => $ssl_ephemeral_file    ? { default => $ssl_ephemeral_file,    '' => $ldap::utils::config::ssl_ephemeral_file    },
      ssl_minimum           => $ssl_minimum           ? { default => $ssl_minimum,           '' => $ldap::utils::config::ssl_minimum           },
      ssl_mode              => $ssl_mode              ? { default => $ssl_mode,              '' => $ldap::utils::config::ssl_mode              },
      sasl_minssf           => $sasl_minssf           ? { default => $sasl_minssf,           '' => $ldap::utils::config::sasl_minssf           },
      sasl_maxssf           => $sasl_maxssf           ? { default => $sasl_maxssf,           '' => $ldap::utils::config::sasl_maxssf           },
      ssl_cert_country      => $ssl_cert_country      ? { default => $ssl_cert_country,      '' => $ldap::utils::config::ssl_cert_country      },
      ssl_cert_state        => $ssl_cert_state        ? { default => $ssl_cert_state,        '' => $ldap::utils::config::ssl_cert_state        },
      ssl_cert_city         => $ssl_cert_city         ? { default => $ssl_cert_city,         '' => $ldap::utils::config::ssl_cert_city         },
      ssl_cert_organization => $ssl_cert_organization ? { default => $ssl_cert_organization, '' => $ldap::utils::config::ssl_cert_organization },
      ssl_cert_department   => $ssl_cert_department   ? { default => $ssl_cert_department,   '' => $ldap::utils::config::ssl_cert_department   },
      ssl_cert_domain       => $ssl_cert_domain       ? { default => $ssl_cert_domain,       '' => $ldap::utils::config::ssl_cert_domain       },
      ssl_cert_email        => $ssl_cert_email        ? { default => $ssl_cert_email,        '' => $ldap::utils::config::ssl_cert_email        },
      bind_policy           => $bind_policy           ? { default => $bind_policy,           '' => $ldap::utils::config::bind_policy           },
      pam_min_uid           => $pam_min_uid           ? { default => $pam_min_uid,           '' => $ldap::utils::config::pam_min_uid           },
      pam_max_uid           => $pam_max_uid           ? { default => $pam_max_uid,           '' => $ldap::utils::config::pam_max_uid           },
      exec_path             => $exec_path             ? { default => $exec_path,             '' => $ldap::utils::config::exec_path             },
    }
  }
}
