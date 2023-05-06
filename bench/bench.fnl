(local mpack (require :mpack))
(local trie (require :trie))

(fn shift [tbl n]
  "[a b c] -> [b c a], n times (edits in place)"
  (let [len (length tbl)]
    (fcollect [i 0 (- len 1)]
      (. tbl (+ 1 (math.fmod (+ i n) len))))))

; inline tests
(let [t [:a :b :c]
      assert=tbl #(assert (and (= (length $1) (length $2))
                               (faccumulate [b true i 1 (length $1)]
                                 (and b (= (. $1 i) (. $2 i)))))
                          ; (.. (fennel.view $1) " not equal " (fennel.view $2))
                          )]
  (assert=tbl [:a :b] [:a :b])
  (assert=tbl t (shift t 0))
  (assert=tbl [:b :c :a] (shift t 1))
  (assert=tbl [:c :a :b] (shift t 2))
  (assert=tbl (shift t 0) (shift t 3))
  (assert=tbl (shift t 1) (shift t 4))
  (assert=tbl (shift t 2) (shift t 5)))

(fn gen-data []
  "Returns an iterator over the dataset to be used"
  (let [words [:src
               :LICENSE
               :license
               :tyle
               :tile
               :local
               :share
               :LICENCE
               :licence
               :home
               :user
               :etc
               :fennel
               :lua
               :bench
               :Make
               :Makefile
               :opt
               :lib
               :Start
               :StArt
               :Aliqua
               :Culpa
               :Lorem
               :LoRem
               :LoREm
               :LOREm
               :LOREM
               :Nisi
               :Nostrud
               :Reprehenderit
               :Sit
               :Voluptate
               :ad
               :adipisicing
               :ADIPISICING
               :aDIPISICING
               :adIPISICING
               :adiPISICING
               :adipISICING
               :adipiSICING
               :adipisICING
               :adipisiCING
               :adipisicING
               :adipisiciNG
               :adipisicinG
               :ADIPISICIng
               :ADIPISICing
               :ADIPISIcing
               :ADIPIsicing
               :ADIPisicing
               :ADIpisicing
               :aDipiSicing
               :adipIsIcing
               :adIpiSICIng
               :adIPISicing
               :aDIpisICING
               :adiPIsicINg
               :aliquip
               :amet
               :Amet
               :aMet
               :anim
               :coMmodo
               :commodo
               :Commodo
               :COmmodo
               :cOmmodo
               :COMmodo
               :COMModo
               :COMMOdo
               :COMMODo
               :COMMODO
               :cOMMODO
               :coMMODO
               :comMODO
               :commODO
               :commoDO
               :consectetur
               :culpa
               :culPa
               :culpA
               :cupidatat
               :cUpidatat
               :cuPidatat
               :dolor
               :dolOr
               :duis
               :dUis
               :duIs
               :duiS
               :ea
               :eA
               :eiusmod
               :elit
               :enim
               :eNim
               :esSe
               :esse
               :est
               :esT
               :et
               :eT
               :ex
               :eX
               :EX
               :excepteur
               :eXcepteur
               :exErcitation
               :fugiat
               :id
               :in
               :ipsum
               :irure
               :labore
               :labOris
               :laboRis
               :laborIs
               :minim
               :mollit
               :nisi
               :nisI
               :non
               :nosTrud
               :nostrud
               :nulla
               :nUlla
               :nuLla
               :occaecat
               :offIcia
               :offiCia
               :officIa
               :officiA
               :pariatur
               :proident
               :prOident
               :repRehenderit
               :reprEhenderit
               :repreHenderit
               :sint
               :sinT
               :sit
               :sunt
               :sUnt
               :suNt
               :uLlamco
               :ut
               :uT
               :vElit
               :voLuptate
               :voluptate
               :END]
        len (length words)]
    (var i 0)
    (fn []
      (if (< i len)
          (do
            (set i (+ i 1))
            (values (shift words i) "@"))))))

(λ build-trie [data-iterator]
  "Insert all of data in the trie"
  (let [trie1 (trie.new)]
    (each [k v data-iterator]
      (trie1.set-value k v))
    trie1))

(λ measure-memory-use [title ?data]
  "Measure memory use, with only some values in scope. Skipped when we measure the CPU time of the program"
  (if (not _G.benchmarking)
      (do
        (print (.. "## " title))
        (collectgarbage :collect)
        (->> (collectgarbage :count)
             (print "Memory used after collect (KiB):"))))
  ?data)

(λ many-gets [trie]
  "Perform many lookups through the trie"
  (each [k v (gen-data)]
    (let [got (trie.get-value k)]
      (assert (= got v) (.. "unexpected value: " got)))))

(->> (measure-memory-use "Program start") (gen-data)
     (measure-memory-use "Before building the trie") (build-trie)
     (measure-memory-use "With the trie") (many-gets)
     (measure-memory-use "Without the trie"))

