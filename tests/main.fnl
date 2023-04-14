;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.

(local fennel (require :fennel))

(local Trie (require :trie))

(let [trie (Trie.new)]
  (assert (not= trie nil))
  (trie:add [:home :user :ghq :proj1])
  (print (fennel.view trie))
  (trie:add [:home :user :ghq :proj2])
  (print (fennel.view trie)))

