require 'intacct_ruby/response'
require 'intacct_ruby/exceptions/function_failure_exception'
require 'builder'
require 'response_factory'
require 'net/http'

include IntacctRuby

describe Response do
  context 'given a 2xx-range response' do
    context 'given successful transactions' do
      let(:response) do
        mock 'Net::HTTPResponse' do
          stubs(:body).returns ResponseFactory.generate_success
          stubs(:value).returns nil
        end
      end

      describe :create do
        it 'throws no runtime errors' do
          expect { Response.new(response) }.not_to raise_error
        end
      end

      describe :function_errors do
        it 'shows no function errors' do
          expect(Response.new(response).function_errors).to be_empty
        end
      end
    end

    context 'given unsuccessful transactions' do
      describe :create do
        function_errors = %w(error1 error2)
        response_body = ResponseFactory.generate_with_errors(function_errors)

        let(:response) do
          mock 'Net::HTTPResponse' do
            stubs(:value)
            stubs(:body).returns(response_body)
          end
        end

        it 'raises FunctionFailureException on invocation' do
          expect { Response.new(response) }
            .to raise_error(
              Exceptions::FunctionFailureException,
              function_errors.join("\n")
            )
        end
      end
    end
  end

  context 'given a non-2xx response' do
    exception = StandardError.new('Some HTTP Error')

    let(:response) do
      mock 'Net::HTTPResponse' do
        stubs(:body)
        stubs(:value).raises(exception)
      end
    end

    describe :create do
      it 'raises an error on instantiation' do
        expect { Response.new(response) }.to raise_error(exception)
      end
    end
  end
end
