def get_podiums_me
    base_uri = $env.data.dig('third_parties', 'podiums', 'base_uri')
    bearer_token = $env.data.dig('third_parties', 'podiums', 'bearer_token')
    response = simple_get_body(base_uri + '/me', {}, { 'Authorization' => bearer_token })
    return response
end

PodiumsReview = Struct.new(
    :id,
    :inferred_rating,
    :sort_rating,
    :bucket,
    :comment,
    :media_title,
    :media_subtitle,
    :media_image_uri,
)

def get_podiums_reviews
    # TODO: handle paginated API
    base_uri = $env.data.dig('third_parties', 'podiums', 'base_uri')
    bearer_token = $env.data.dig('third_parties', 'podiums', 'bearer_token')
    response = simple_get_body(base_uri + '/users/louisinlvx/reviews', {}, { 'Authorization' => bearer_token })
    result = []
    for review in response['reviews'] do
        next unless review.dig('mediaType') == 'song'
        result << PodiumsReview.new(
            review.dig('_id'),
            review.dig('inferredRating'),
            review.dig('sortRating'),
            review.dig('bucket'),
            review.dig('comment'),
            review.dig('mediaTitle'),
            review.dig('mediaSubtitle'),
            review.dig('mediaImageURI'),
        )
    end
    return result
end

# {"_id" => "69f7ea9ceafe78dffd9bd121", "inferredRating" => 9.5, "sortRating" => 9.5, "bucket" => "high", "bucketOrder" => 3, "tags" => [], "collections" => [], "mediaTitle" => "sugarblind", "mediaSubtitle" => "KiNG MALA", "mediaImageURI" => "https://i.scdn.co/image/ab67616d00001e02f09f395bd8eef832952ede3f", "mediaExternalID" => "spotify:track:4Qj9FqeX4cKfBH44rel81X", "createdAt" => "2026-05-04T00:38:52.592Z", "updatedAt" => "2026-05-04T00:50:26.099Z", "user" => {"_id" => "69f7ea1deafe78dffd9ba044", "username" => "louisinlvx", "firstName" => "Louis", "lastName" => "Machin", "profilePicture" => "https://firebasestorage.googleapis.com/v0/b/fourth-return-410405.appspot.com/o/louisinlvx.jpeg?alt=media&token=956c142b-d9b6-47d4-a91f-57bc2e8476c4&v=1777855552925", "backgroundType" => "system"}, "mediaType" => "song", "numComments" => 0, "numShares" => 0, "numWatchlists" => 0, "myReviewId" => "69f7ea9ceafe78dffd9bd121", "myWatchlist" => false, "photos" => [], "files" => [], "subMedia" => []}
# {"_id" => "69f7ed51eafe78dffd9cd248", "inferredRating" => 7.375, "sortRating" => 7.375, "bucket" => "high", "bucketOrder" => 10, "comment" => "feels unfinished but a great sound", "tags" => [], "collections" => [], "mediaTitle" => "Sour Switchblade", "mediaSubtitle" => "Elita", "mediaImageURI" => "https://i.scdn.co/image/ab67616d00001e02983f6e0739cdb099c9cf99b5", "mediaExternalID" => "spotify:track:5efTda0aHZNWNB5srlwFmK", "createdAt" => "2026-05-04T00:50:25.932Z", "updatedAt" => "2026-05-04T00:50:26.099Z", "user" => {"_id" => "69f7ea1deafe78dffd9ba044", "username" => "louisinlvx", "firstName" => "Louis", "lastName" => "Machin", "profilePicture" => "https://firebasestorage.googleapis.com/v0/b/fourth-return-410405.appspot.com/o/louisinlvx.jpeg?alt=media&token=956c142b-d9b6-47d4-a91f-57bc2e8476c4&v=1777855552925", "backgroundType" => "system"}, "mediaType" => "song", "numComments" => 0, "numShares" => 0, "numWatchlists" => 0, "myReviewId" => "69f7ed51eafe78dffd9cd248", "myWatchlist" => false, "photos" => [], "files" => [], "subMedia" => []}
