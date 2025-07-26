(define-non-fungible-token proof-nft uint)

(define-data-var attempt-id uint u1)
(define-map has-attempted principal bool)

;; Mint NFT to participant if not already claimed
(define-public (claim-proof)
  (begin
    (asserts! (is-none (map-get? has-attempted tx-sender)) (err u100)) ;; Already claimed
    (let ((id (var-get attempt-id)))
      (try! (nft-mint? proof-nft id tx-sender))
      (map-set has-attempted tx-sender true)
      (var-set attempt-id (+ id u1))
      (ok {id: id, participant: tx-sender})
    )
  )
)

;; Check if a user already received their NFT
(define-read-only (has-user-participated (user principal))
  (ok (default-to false (map-get? has-attempted user))))
