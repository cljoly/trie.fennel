;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.

(local Trie {;; Whether the path is terminal
             :value false
             ;; Table (string => Trie)
             :next nil})

;; Constructor

(fn Trie.new [self]
  (let [trie {}]
    (setmetatable trie Trie)
    (setmetatable trie {:__index Trie})
    (set Trie.__self Trie)
    trie))

;; Methods

(fn get_or_insert [fn_default table ...]
  "... is the key"
  (let [value (?. table ...)]
    (if (not value)
        (let [default (fn_default)]
          (tset table ... default)
          default)
        value)))

(fn Trie.add [self path_string_list]
  (match path_string_list
    nil nil
    [head & ?tail] (let [next_table (get_or_insert #{} self :next)
                         sub_trie (get_or_insert Trie.new self :next head)]
                     (assert (not= next_table nil))
                     (assert (not= sub_trie nil))
                     (sub_trie:add (or ?tail []))
                     sub_trie)
    [] (do
         (tset self :value true)
         self)))

;; Return the Trie class

Trie

