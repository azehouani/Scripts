
tag_and_push() {
  local tag="$1"
  [ -z "$tag" ] && { echo "Usage: tag_and_push <tag-name>"; return 1; }

  # Delete local tag if it exists
  git rev-parse "$tag" && git tag -d "$tag"

  # Delete remote tag if it exists
  git ls-remote --tags origin | grep "refs/tags/$tag$" && git push --delete origin "$tag"

  # Create and push new tag
  git tag "$tag"
  git push origin "$tag"

  echo "Tag '$tag' created and pushed to current commit."
}
