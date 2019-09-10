module Pipeline::Build
  class BuildImage
    include Mandate

    attr_accessor :target_sha

    initialize_with :build_tag, :image_slug, :repo, :img

    def call
      repo.fetch!
      checkout
      build
      local_tag
    end

    def checkout
      @target_sha = repo.checkout(build_tag)
    end

    def build
      Dir.chdir(repo.workdir) do
        img.build(local_tag)
      end
    end

    def local_tag
      "#{image_slug}:#{target_sha}"
    end
  end
end
