;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.

(local fennel (require :fennel))

(local Trie (require :trie))

(let [trie (Trie.new)]
  (print (trie.view))
  (assert (not= trie nil))
  (let [common-path #[:home :user :ghq $1]
        proj1 (common-path :proj1)
        proj2 (common-path :proj2)
        proj3 (common-path :proj3)]
    (trie.set-value proj1 true)
    (print (trie.view))
    (assert (trie.get-value proj1) "proj1 not found (first time)")
    (assert (not (trie.get-value proj3)) "proj3 found")
    ;;
    (trie.set-value proj2 true)
    (print (trie.view))
    (assert (trie.get-value proj1) "proj1 not found (second time)")
    (assert (trie.get-value proj2) "proj2 not found")
    (assert (not (trie.get-value proj3)) "proj3 found")))

