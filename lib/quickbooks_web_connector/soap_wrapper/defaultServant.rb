module QuickbooksWebConnector
  module SoapWrapper

    class QBWebConnectorSvcSoap
      # SYNOPSIS
      #   serverVersion(parameters)
      #
      # ARGS
      #   parameters      ServerVersion - {http://developer.intuit.com/}serverVersion
      #
      # RETURNS
      #   parameters      ServerVersionResponse - {http://developer.intuit.com/}serverVersionResponse
      #
      def serverVersion(parameters)
        ServerVersionResponse.new(QuickbooksWebConnector.config.server_version)
      end

      # SYNOPSIS
      #   clientVersion(parameters)
      #
      # ARGS
      #   parameters      ClientVersion - {http://developer.intuit.com/}clientVersion
      #
      # RETURNS
      #   parameters      ClientVersionResponse - {http://developer.intuit.com/}clientVersionResponse
      #
      def clientVersion(parameters)
        clientVersionResult = nil

        if QuickbooksWebConnector.config.minimum_web_connector_client_version && QuickbooksWebConnector.config.minimum_web_connector_client_version.to_s > parameters.strVersion
          clientVersionResult = "E:This version of QuickBooks Web Connector is outdated. Version #{QuickbooksWebConnector.config.minimum_web_connector_client_version} or greater is required."
        end

        ClientVersionResponse.new(clientVersionResult)
      end

      # SYNOPSIS
      #   authenticate(parameters)
      #
      # ARGS
      #   parameters      Authenticate - {http://developer.intuit.com/}authenticate
      #
      # RETURNS
      #   parameters      AuthenticateResponse - {http://developer.intuit.com/}authenticateResponse
      #
      def authenticate(parameters)
        token = SecureRandom.uuid
        result = if parameters.strUserName == QuickbooksWebConnector.config.username && parameters.strPassword == QuickbooksWebConnector.config.password
          if QuickbooksWebConnector.size > 0
            QuickbooksWebConnector.config.company_file_path
          else
            'none'
          end
        else
          'nvu'
        end

        AuthenticateResponse.new([token, result, nil, nil])
      end

      # SYNOPSIS
      #   sendRequestXML(parameters)
      #
      # ARGS
      #   parameters      SendRequestXML - {http://developer.intuit.com/}sendRequestXML
      #
      # RETURNS
      #   parameters      SendRequestXMLResponse - {http://developer.intuit.com/}sendRequestXMLResponse
      #
      def sendRequestXML(parameters)
        job = QuickbooksWebConnector::Job.peek
        request_xml = job ? job.request_xml : nil

        SendRequestXMLResponse.new request_xml
      end

      # SYNOPSIS
      #   receiveResponseXML(parameters)
      #
      # ARGS
      #   parameters      ReceiveResponseXML - {http://developer.intuit.com/}receiveResponseXML
      #
      # RETURNS
      #   parameters      ReceiveResponseXMLResponse - {http://developer.intuit.com/}receiveResponseXMLResponse
      #
      def receiveResponseXML(parameters)
        job = QuickbooksWebConnector::Job.reserve
        job.response_xml = parameters.response
        job.perform

        # TODO: This just returns 1% by default. Need a way to determine the actual percentage done.
        progress = QuickbooksWebConnector.size == 0 ? 100 : 1

        ReceiveResponseXMLResponse.new(progress)
      end

      # SYNOPSIS
      #   connectionError(parameters)
      #
      # ARGS
      #   parameters      ConnectionError - {http://developer.intuit.com/}connectionError
      #
      # RETURNS
      #   parameters      ConnectionErrorResponse - {http://developer.intuit.com/}connectionErrorResponse
      #
      def connectionError(parameters)
        p [parameters]
        raise NotImplementedError.new
      end

      # SYNOPSIS
      #   getLastError(parameters)
      #
      # ARGS
      #   parameters      GetLastError - {http://developer.intuit.com/}getLastError
      #
      # RETURNS
      #   parameters      GetLastErrorResponse - {http://developer.intuit.com/}getLastErrorResponse
      #
      def getLastError(parameters)
        p [parameters]
        raise NotImplementedError.new
      end

      # SYNOPSIS
      #   closeConnection(parameters)
      #
      # ARGS
      #   parameters      CloseConnection - {http://developer.intuit.com/}closeConnection
      #
      # RETURNS
      #   parameters      CloseConnectionResponse - {http://developer.intuit.com/}closeConnectionResponse
      #
      def closeConnection(parameters)
        CloseConnectionResponse.new
      end
    end

  end
end
