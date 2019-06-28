namespace :power do
  desc 'Import cleared offers from the emi website'
  task emi_cleared_data_daily_import: :environment do
    p 'hello there'
    # response = RestClient::Request.execute(
    #   method: :get,
    #   url: 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/BidsAndOffers/Bids/2018/20181015_Bids.csv'
    #   )
    #   # pp JSON.parse(response)['id']
    #   pp response

    # Create a BlobService object
    # blob_client = Azure::Storage::Blob::BlobService.create(options=
    #   {use_path_style_uri: 'https://emidatasets.blob.core.windows.net/publicdata?sv=2018-03-28&si=exp2019-12-31&sr=c&sig=RgEr3fnUCRgCg%2FGc%2BYus0OJHXpWQBZvUPpIDxsOtJQE%3D'}
    #   )

    # Download the blob(s).
    # Add '_DOWNLOADED' as prefix to '.txt' so you can see both files in Documents.
    # full_path_to_file2 = File.join(local_path, local_file_name.gsub('.txt', '_DOWNLOADED.txt'))

    # puts "\n Downloading blob to " + full_path_to_file2
    # blob, content = blob_client.get_blob(container_name,local_file_name)
    # File.open(full_path_to_file2,"wb") {|f| f.write(content)}
    # pp blob_client.get_blob('publicdata', 'Datasets/Wholesale/BidsAndOffers/Bids/2018/20181015_Bids.csv')

    url = 'https://emidatasets.blob.core.windows.net/publicdata/Datasets/Wholesale/BidsAndOffers/Bids/2018/20181015_Bids.csv'
    response = HTTParty.get(url)

    puts response.body, response.code, response.message, response.headers.inspect




  end
end