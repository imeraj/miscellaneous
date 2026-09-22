# HMAC
generate_hmac = fn secret_key, payload ->
  :hmac
  |> :crypto.mac(:sha256, secret_key, payload)
  |> Base.encode64()
end

validate_hmac = fn secret_key, payload, expected_hash ->
  :hmac
  |> :crypto.mac(:sha256, secret_key, payload)
  |> Base.encode64()
  |> Kernel.==(expected_hash)
end

payload = :erlang.term_to_binary(%{some: "Data", i: "Need"})

secret_key = "this_is_a_secret_and_secure_key"

correct_hmac_hash = generate_hmac.(secret_key, payload)

validate_hmac.("INVALID_KEY", payload, correct_hmac_hash) |> IO.inspect()

validate_hmac.(secret_key, payload, correct_hmac_hash) |> IO.inspect()

# Symmetric encryption
encrypt =
  fn message, key ->
    opts = [encrypt: true, padding: :zero]
    :crypto.crypto_one_time(:aes_256_ecb, key, message, opts)
  end

decrypt =
  fn payload, key ->
    opts = [encrypt: false]

    :aes_256_ecb
    |> :crypto.crypto_one_time(key, payload, opts)
    |> String.trim(<<0>>)
  end

message = "This is a secret message"

secret_key = :crypto.strong_rand_bytes(32)

encrypted_message = encrypt.(message, secret_key) |> IO.inspect()

try do
  decrypt.(encrypted_message, "INVALID KEY")
rescue
  error -> error
end
|> IO.inspect()

decrypt.(encrypted_message, :crypto.strong_rand_bytes(32)) |> IO.inspect()

decrypt.(encrypted_message, secret_key) |> IO.inspect()
