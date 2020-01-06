if defined? Swagger
  Swagger::Docs::Config.register_apis(
    '0.1' => {
      api_extension_type: :json,
      api_file_path: 'docs/api',
      base_path: '/api',
      clean_directory: false,
      attributes: {
        info: {
          title: 'Soundstorm API',
          description: <<~TEXT
            This is the REST API for all Soundstorm servers. When authenticated
            using an OAuth access token, all of these endpoints are available
            to use.
          TEXT
        }
      }
    }
  )
end
