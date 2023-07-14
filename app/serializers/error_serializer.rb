class ErrorSerializer
  def self.serialize_error(error)
    {
      errors: [
        {
          detail: error.message
        }

      ]
    }
  end
end