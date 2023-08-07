
module JQ
  def self.jq(*args, json: true, stdin_data: nil, **kwargs)
    txt, status = ::Open3.capture2("jq", "--sort-keys", *args.map(&:to_s), stdin_data:, **kwargs)
    ::Kernel.raise(status.to_s) unless status.success?
    json ? ::JSON.parse(txt) : txt
  end

  def jq(*args, **kwargs)
    ::JQ.jq(*args, **kwargs)
  end
end
