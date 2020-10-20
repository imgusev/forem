require "rails_helper"

RSpec.describe SpotifyTag, type: :liquid_tag do
  describe "#link" do
    let(:valid_uri) { "spotify:track:0K1UpnetfCKtcNu37rJmCg" }
    let(:valid_playlist_uri) { "spotify:playlist:37i9dQZF1E36t2Deh8frhL" }
    let(:legacy_playlist_uri) { "spotify:user:spotify:playlist:37i9dQZF1E36t2Deh8frhL" }
    let(:invalid_uri) { "asdfasdf:asdfasdf:asdfasdf" }

    def generate_tag(link)
      Liquid::Template.register_tag("spotify", SpotifyTag)
      Liquid::Template.parse("{% spotify #{link} %}")
    end

    def generate_iframe(embed_path, height)
      <<~HTML
        <iframe
          width="100%"
          height="#{height}px"
          scrolling="no"
          frameborder="0"
          allowtransparency="true"
          allow="encrypted-media"
          src="https://open.spotify.com/embed/#{embed_path}"
          loading="lazy">
        </iframe>
      HTML
    end

    it "generals the proper iframe if the uri is valid" do
      expect(generate_tag(valid_uri).render).to eq(generate_iframe("track/0K1UpnetfCKtcNu37rJmCg", 80))
    end

    it "does not raise an error if the uri is valid" do
      expect { generate_tag(valid_uri) }.not_to raise_error
    end

    it "does not raise an error if the playlist uri is valid" do
      expect { generate_tag(valid_playlist_uri) }.not_to raise_error
    end

    it "does not raise an error for a legacy playlist URI" do
      expect { generate_tag(legacy_playlist_uri) }.not_to raise_error
    end

    it "raises an error if the uri is invalid" do
      message = "Invalid Spotify Link - Be sure you're using the uri of a specific track, " \
        "album, artist, playlist, or podcast episode."
      expect do
        generate_tag(invalid_uri)
      end.to raise_error(StandardError, message)
    end
  end
end
