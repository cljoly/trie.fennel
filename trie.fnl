;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.

(local fennel (require :fennel))

(fn new [value]
  (var children {})
  (var val value)

  (fn get-value [path]
    "Get the value at the given path. [] is the root"
    (match path
      nil nil
      [head & tail] (let [subtrie (?. children head)]
                      (if subtrie
                          (subtrie.get-value tail)
                          nil))
      [] val))

  (fn set-value [path value]
    "Set the value for the given path. [] will set the root value"
    (match path
      nil nil
      [head & tail] (let [subtrie (or (?. children head) (new))]
                      (tset children head subtrie)
                      (subtrie.set-value tail value))
      [] (set val value)))

  (fn view []
    "Returns a string to view the content of the trie, recursively"
    (string.format "Trie{:val %q :children {%s}" val
                   (accumulate [s "" k v (pairs children)]
                     (.. s (string.format ":%s %s " k (v.view)))) "}"))

  {: get-value : set-value : view})

{: new}

