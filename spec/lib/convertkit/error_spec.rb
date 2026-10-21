describe ConvertKit::RateLimitError do
  it 'keeps a Symbol-keyed Hash as the message' do
    error = (raise ConvertKit::RateLimitError, { errors: ['Too many requests'] } rescue $!)

    expect(error).to be_a(ConvertKit::RateLimitError)
    expect(error.message).to eq({ errors: ['Too many requests'] }.to_s)
    expect(error.status).to be_nil
    expect(error.retry_after).to be_nil
  end
end
