;; Copyright 2023 Clément Joly <foss@131719.xyz>
;;
;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.

(fn new []
  "Create a new Trie (which is also a trie node). Notes:
   * Nil paths are not allowed
   * Nil values are not allowed either"
  (let [self {:children {} :val nil}]
    (fn fennelview []
      "Returns a string to view the content of the trie, recursively. Requires fennel at runtime."
      (let [(found fennel) (pcall require :fennel)]
        (if found
            (.. "#trie" (fennel.view self))
            (error "fennel is required to view the content of the trie. Please install fennel-lang.org as a Lua library"))))

    (fn get-value [path]
      "Get the value at the given path. [] is the root"
      (match path
        [head & tail] (let [subtrie (?. self :children head)]
                        (if subtrie
                            (subtrie.get-value tail)
                            nil))
        [] self.val))

    (fn set-value [path value]
      "Set the value for the given path. [] will set the root value"
      (if (= value nil)
          nil ; Early exit
          (match path
            [head & tail] (let [subtrie (or (?. self :children head) (new))]
                            (tset self :children head subtrie)
                            (subtrie.set-value tail value))
            [] (tset self :val value))))

    (fn get-deepest-path [path value]
      "Get the deepest path with value. Complexity: at most O(n), with n the length of the path."
      (match (values path value)
        ([head] value) (if (= (get-value path) value) path
                           (do
                             (table.remove path)
                             (get-deepest-path path value)))
        ([] self.val) []
        _ nil))

    (-> {: get-value : set-value : get-deepest-path}
        (setmetatable {:__fennelview fennelview}))))

{: new}

