class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true

  mount_uploader :file, FileUploader
end
