;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.

(local fennel (require :fennel))

(local Trie (require :trie))

;; Test setter getter
(let [trie (Trie.new)
      proj1 #[:home :user :ghq :proj1]
      proj2 #[:home :user :ghq :proj1 :src :proj2]
      proj3 #[:home :user :ghq :proj3]]
  (assert (not= trie nil))
  ;;
  (trie.set-value (proj1) true)
  (assert (trie.get-value (proj1)) "proj1 not found (first time)")
  (assert (not (trie.get-value (proj3))) "proj3 found")
  ;;
  (trie.set-value (proj2) true)
  (assert (trie.get-value (proj1)) "proj1 not found (second time)")
  (assert (trie.get-value (proj2)) "proj2 not found")
  (assert (not (trie.get-value (proj3))) "proj3 found"))

(fn deep= [table1 table2]
  "Whether or not table1’s content is the same as table2’s content"
  (and (= (type table1) :table) (= (type table2) :table)
       (= (length table1) (length table2))
       (accumulate [b true i v (ipairs table1)]
         (and b (= (. table2 i) v)))))

;; Test deepest path
(let [trie (Trie.new)
      proj1 #[:home :user :ghq :proj1]
      proj-inside #[:home :user :ghq :proj1 :src :module :proj2]
      proj3 #[:home :user :proj3]]
  (trie.set-value [] true)
  (trie.set-value (proj1) true)
  (trie.set-value (proj-inside) true)
  (trie.set-value (proj3) true)
  ;;
  (let [deepest-path (-> (doto (proj1) (table.insert :a) (table.insert :b)
                           (table.insert :c))
                         (trie.get-deepest-path true))]
    (assert (deep= deepest-path (proj1))
            (.. "not equal to proj1: got " (fennel.view deepest-path))))
  (assert (= nil (trie.get-deepest-path proj-inside 10))
          "should return nil on not-found values")
  (assert (= nil (trie.get-deepest-path proj-inside nil))
          "should return nil on nil values")
  (assert (= nil (trie.get-deepest-path [] 10))
          "should return nil on not-found root")
  (assert (deep= [] (trie.get-deepest-path [] true))
          "should return root on found root")
  (assert (= nil (trie.get-deepest-path nil true))
          "should return nil on nil path")
  (assert (= nil (trie.get-deepest-path nil nil))
          "should return nil on nil path and value")
  (print "Test view: " (fennel.view trie)))

(print "\027[32mOK\027(B\027[m")

