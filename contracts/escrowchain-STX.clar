;; --------------------------------------------------
;; EscrowChain-STX
;; A Decentralized Escrow + Arbitration Smart Contract
;; --------------------------------------------------

(define-data-var escrow-counter uint u0)

;; Escrow structure
(define-map escrows
  uint
  {
    buyer: principal,
    seller: principal,
    arbitrator: principal,
    amount: uint,
    deadline: uint,
    is-disputed: bool,
    released: bool
  }
)

;; ---------------------------
;; Events
;; ---------------------------
;; Event logs are not natively supported in Clarity. Use `print` for debugging purposes.
;; Example: (print {event: "escrow-created", id: id, buyer: tx-sender, seller: seller, amount: amount, deadline: deadline})

;; ---------------------------
;; Functions
;; ---------------------------

;; Create a new escrow
;; Fixed duplicate print statement and missing closing parenthesis
(define-public (create-escrow (seller principal) (arbitrator principal) (amount uint) (deadline uint))
  (begin
    (var-set escrow-counter (+ (var-get escrow-counter) u1))
    (let ((id (var-get escrow-counter)))
      (map-set escrows id {
        buyer: tx-sender,
        seller: seller,
        arbitrator: arbitrator,
        amount: amount,
        deadline: deadline,
        is-disputed: false,
        released: false
      })
      (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
      (print {event: "escrow-created", id: id, buyer: tx-sender, seller: seller, amount: amount, deadline: deadline})
      (ok id)
    )
  )
)

;; Release funds to seller (if no dispute)
;; Fixed duplicate print statement and missing closing parenthesis
(define-public (release-payment (id uint))
  (let ((escrow (map-get? escrows id)))
    (if (is-some escrow)
        (let ((data (unwrap-panic escrow)))
          (if (and (not (get is-disputed data)) (not (get released data)))
              (begin
                (map-set escrows id (merge data { released: true }))
                (try! (stx-transfer? (get amount data) (as-contract tx-sender) (get seller data)))
                (print {event: "escrow-released", id: id, to: (get seller data), amount: (get amount data)})
                (ok true)
              )
              (err u102) ;; Already released or disputed
          )
        )
        (err u404) ;; Escrow not found
    )
  )
)

;; Refund funds to buyer
;; Fixed duplicate print statement and missing closing parenthesis
(define-public (refund-payment (id uint))
  (let ((escrow (map-get? escrows id)))
    (if (is-some escrow)
        (let ((data (unwrap-panic escrow)))
          (if (and (not (get is-disputed data)) (not (get released data)))
              (begin
                (map-set escrows id (merge data { released: true }))
                (try! (stx-transfer? (get amount data) (as-contract tx-sender) (get buyer data)))
                (print {event: "escrow-refunded", id: id, to: (get buyer data), amount: (get amount data)})
                (ok true)
              )
              (err u102) ;; Already released or disputed
          )
        )
        (err u404)
    )
  )
)

;; Raise a dispute
;; Fixed duplicate print statement and missing closing parentheses
(define-public (raise-dispute (id uint))
  (let ((escrow (map-get? escrows id)))
    (if (is-some escrow)
        (let ((data (unwrap-panic escrow)))
          (begin
            (map-set escrows id (merge data { is-disputed: true }))
            (print {event: "escrow-disputed", id: id, by: tx-sender})
            (ok true)
          )
        )
        (err u404)
    )
  )
)

;; Resolve dispute (arbitrator decides)
;; Fixed duplicate print statement and missing closing parenthesis
(define-public (resolve-dispute (id uint) (winner principal))
  (let ((escrow (map-get? escrows id)))
    (if (is-some escrow)
        (let ((data (unwrap-panic escrow)))
          (if (and (get is-disputed data) (is-eq tx-sender (get arbitrator data)))
              (begin
                (map-set escrows id (merge data { released: true }))
                (try! (stx-transfer? (get amount data) (as-contract tx-sender) winner))
                (print {event: "escrow-resolved", id: id, winner: winner})
                (ok true)
              )
              (err u101) ;; Not arbitrator or not disputed
          )
        )
        (err u404)
    )
  )
)

;; Auto release if deadline passed & no dispute
;; Fixed incorrect print statement syntax
(define-public (auto-release (id uint))
  (let ((escrow (map-get? escrows id)))
    (if (is-some escrow)
        (let ((data (unwrap-panic escrow)))
          (if (and (not (get is-disputed data)) (<= (get deadline data) stacks-block-height) (not (get released data)))
              (begin
                (map-set escrows id (merge data { released: true }))
                (try! (stx-transfer? (get amount data) (as-contract tx-sender) (get seller data)))
                (print {event: "escrow-released", id: id, to: (get seller data), amount: (get amount data)})
                (ok true)
              )
              (err u103) ;; Not yet expired or already released
          )
        )
        (err u404)
    )
  )
)
