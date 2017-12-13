require "set"
require "rspec"

def connected(graph, start_node)
  to_visit = Set.new([start_node])
  visited = Set.new

  while (node = to_visit.first) && to_visit.delete(node)
    visited << node
    to_visit |= (graph[node] - visited)
  end

  visited
end

def groups(graph)
  groups = Set.new
  to_visit = Set.new(graph.keys)

  while (node = to_visit.first) && to_visit.delete(node)
    groups << (group = connected(graph, node))
    to_visit -= group
  end

  groups
end

describe "connected" do
  let(:graph) do
    {
      0 => Set.new([2]),
      1 => Set.new([1]),
      2 => Set.new([0, 3, 4]),
      3 => Set.new([2, 4]),
      4 => Set.new([2, 3, 6]),
      5 => Set.new([6]),
      6 => Set.new([4, 5])
    }
  end

  specify "1 connected to 1" do
    expect(connected(graph, 1)).to eq Set.new([1])
  end

  specify "0 connected to 0, 2, 3, 4, 5, 6" do
    expect(connected(graph, 0)).to eq Set.new([0, 2, 3, 4, 5, 6])
  end

  specify "groups" do
    expect(groups(graph)).to eq Set.new([Set.new([1]), Set.new([0, 2, 3, 4, 5, 6])])
  end
end


graph_spec = Hash[<<-GRAPHSPEC.split("\n").map { |line| node, nodes = line.split("<->"); [node.strip.to_i, Set.new(nodes.split(",").map(&:strip).map(&:to_i))] }]
0 <-> 412, 480, 777, 1453
1 <-> 132, 1209
2 <-> 1614
3 <-> 3
4 <-> 1146
5 <-> 5, 528
6 <-> 107, 136, 366, 1148, 1875
7 <-> 452, 701, 1975
8 <-> 164
9 <-> 912, 920
10 <-> 152
11 <-> 1109
12 <-> 1282
13 <-> 17, 793
14 <-> 1665
15 <-> 21, 1413
16 <-> 233, 1297
17 <-> 13
18 <-> 506
19 <-> 1709
20 <-> 1526
21 <-> 15, 59, 106
22 <-> 756, 923, 1698
23 <-> 94, 191, 206, 443
24 <-> 24, 1996
25 <-> 495
26 <-> 572
27 <-> 920, 1127
28 <-> 447, 1304
29 <-> 29, 142, 474, 552, 1089
30 <-> 259
31 <-> 840, 1224
32 <-> 1839
33 <-> 653, 1054
34 <-> 856, 1185
35 <-> 842
36 <-> 1172, 1247, 1676
37 <-> 666, 1606
38 <-> 414, 650
39 <-> 238, 1344
40 <-> 331, 1517
41 <-> 276, 631
42 <-> 953, 1096
43 <-> 872
44 <-> 882, 1274
45 <-> 980, 1600
46 <-> 800, 1372, 1978
47 <-> 394, 662, 1442
48 <-> 924, 1229, 1759, 1838
49 <-> 112
50 <-> 50, 852, 1751
51 <-> 310, 591, 920
52 <-> 313, 779
53 <-> 922, 1702
54 <-> 54
55 <-> 648
56 <-> 402
57 <-> 926, 1169
58 <-> 731, 1007, 1129, 1629, 1659
59 <-> 21, 602
60 <-> 1159
61 <-> 61, 683
62 <-> 803, 1232, 1348, 1720
63 <-> 1012, 1461
64 <-> 542, 965
65 <-> 640, 665
66 <-> 761, 1001
67 <-> 782, 1813
68 <-> 68
69 <-> 133, 651
70 <-> 1827
71 <-> 217
72 <-> 491, 1862
73 <-> 295
74 <-> 282, 964
75 <-> 710, 1075, 1194, 1411
76 <-> 263, 1027, 1877
77 <-> 597, 846
78 <-> 880, 983, 997
79 <-> 1398
80 <-> 1023, 1812
81 <-> 370, 1120, 1312
82 <-> 1840, 1979
83 <-> 691, 1603
84 <-> 84, 182
85 <-> 928
86 <-> 666, 1274, 1310, 1479
87 <-> 861, 1065, 1595, 1777
88 <-> 1588
89 <-> 1877
90 <-> 1305, 1458, 1531
91 <-> 456, 1115
92 <-> 1167, 1396
93 <-> 617
94 <-> 23
95 <-> 508, 1260
96 <-> 1622, 1912
97 <-> 97
98 <-> 995, 1589
99 <-> 474
100 <-> 218, 1018
101 <-> 1335
102 <-> 675, 1368
103 <-> 1013
104 <-> 832, 1730
105 <-> 950
106 <-> 21, 1008
107 <-> 6, 998
108 <-> 108
109 <-> 109, 368, 941
110 <-> 417, 502, 865
111 <-> 1459, 1967
112 <-> 49, 1931
113 <-> 767, 790, 1367
114 <-> 1347, 1421, 1879
115 <-> 707, 1714
116 <-> 116
117 <-> 154, 1431
118 <-> 327, 1062
119 <-> 1461
120 <-> 1088
121 <-> 434, 1659
122 <-> 841, 930, 1222
123 <-> 1960
124 <-> 360, 416, 536, 961, 1498
125 <-> 946, 1455, 1992
126 <-> 512, 1694
127 <-> 1131, 1201
128 <-> 311
129 <-> 129, 718
130 <-> 1138, 1905
131 <-> 620
132 <-> 1, 255, 1275
133 <-> 69, 589
134 <-> 729, 1002, 1842
135 <-> 1956
136 <-> 6, 1135
137 <-> 367, 375
138 <-> 138, 494
139 <-> 1750
140 <-> 1082, 1501, 1688
141 <-> 1423, 1842
142 <-> 29, 1766
143 <-> 631, 1316
144 <-> 201, 1547
145 <-> 982, 1183, 1908
146 <-> 921, 1094, 1619
147 <-> 595
148 <-> 515, 1008
149 <-> 686
150 <-> 1534, 1704, 1875
151 <-> 996
152 <-> 10, 1274
153 <-> 1512
154 <-> 117
155 <-> 641
156 <-> 185, 1794, 1804
157 <-> 251
158 <-> 874, 1992
159 <-> 637
160 <-> 160, 1057, 1429, 1902
161 <-> 1355
162 <-> 1347
163 <-> 1286
164 <-> 8, 343, 1636
165 <-> 1078, 1098
166 <-> 1325
167 <-> 1900
168 <-> 168
169 <-> 169
170 <-> 736, 1366
171 <-> 171
172 <-> 1860
173 <-> 1874
174 <-> 456
175 <-> 487, 1165
176 <-> 714, 1094, 1477, 1954
177 <-> 330, 1799
178 <-> 623, 975, 1849
179 <-> 454
180 <-> 1408, 1566
181 <-> 181
182 <-> 84, 220
183 <-> 886, 1319, 1443, 1592
184 <-> 983, 1231, 1496
185 <-> 156, 276, 1686
186 <-> 423, 1056
187 <-> 1479
188 <-> 612, 990
189 <-> 391
190 <-> 1188
191 <-> 23, 191
192 <-> 1419, 1671
193 <-> 1825, 1847
194 <-> 608, 899, 1629
195 <-> 195, 1689, 1707
196 <-> 1586
197 <-> 314, 1983
198 <-> 198, 595, 1267
199 <-> 498, 1031, 1316
200 <-> 905, 1266, 1385
201 <-> 144, 1145
202 <-> 250, 1089
203 <-> 1462
204 <-> 528, 1947
205 <-> 205, 1460
206 <-> 23
207 <-> 305, 946
208 <-> 919, 1829
209 <-> 1352
210 <-> 569
211 <-> 1289
212 <-> 493, 1286
213 <-> 720
214 <-> 214, 308, 1426, 1499
215 <-> 518
216 <-> 1129, 1895
217 <-> 71, 608
218 <-> 100, 664
219 <-> 301, 876
220 <-> 182, 754, 1040
221 <-> 1439
222 <-> 1466, 1533, 1852
223 <-> 334, 1866
224 <-> 320, 845, 864, 974
225 <-> 1022, 1417
226 <-> 1464, 1860
227 <-> 651
228 <-> 1187
229 <-> 851
230 <-> 230, 1120, 1576
231 <-> 910
232 <-> 453, 1015, 1498, 1547, 1884
233 <-> 16, 712
234 <-> 1167
235 <-> 601, 670
236 <-> 236
237 <-> 1076, 1922
238 <-> 39, 364, 1241, 1602
239 <-> 632, 913
240 <-> 975
241 <-> 1431, 1819
242 <-> 540
243 <-> 741
244 <-> 697, 1380, 1750, 1883
245 <-> 1790
246 <-> 698, 1791
247 <-> 896
248 <-> 248, 501
249 <-> 513, 730, 1354
250 <-> 202
251 <-> 157, 251, 1719
252 <-> 1421, 1904
253 <-> 1190, 1820
254 <-> 542
255 <-> 132, 593
256 <-> 1778
257 <-> 1249, 1845
258 <-> 572, 1134, 1847
259 <-> 30, 1028, 1264
260 <-> 546, 1270, 1841
261 <-> 261
262 <-> 746, 1068, 1258
263 <-> 76, 885
264 <-> 430, 1304
265 <-> 469, 1046
266 <-> 1511
267 <-> 922, 1245
268 <-> 1337
269 <-> 785
270 <-> 1219
271 <-> 1051
272 <-> 395, 1389, 1706
273 <-> 1242, 1439
274 <-> 1698
275 <-> 1994
276 <-> 41, 185, 1778
277 <-> 1992
278 <-> 340
279 <-> 1739, 1783
280 <-> 1817
281 <-> 499
282 <-> 74, 584
283 <-> 316, 1020, 1612
284 <-> 630, 917
285 <-> 524
286 <-> 614, 1446
287 <-> 641
288 <-> 1203
289 <-> 1003, 1073
290 <-> 1993
291 <-> 957, 1042
292 <-> 292
293 <-> 825
294 <-> 407, 712
295 <-> 73, 733, 1878
296 <-> 986, 1796
297 <-> 1241
298 <-> 1511
299 <-> 467, 660, 1009
300 <-> 1252
301 <-> 219, 506, 1313
302 <-> 478
303 <-> 303, 586, 1656
304 <-> 1724
305 <-> 207
306 <-> 904
307 <-> 417, 1070
308 <-> 214
309 <-> 1402, 1971
310 <-> 51, 371, 403, 794
311 <-> 128, 516, 743
312 <-> 602, 1328
313 <-> 52, 1653
314 <-> 197, 1070
315 <-> 1990
316 <-> 283, 1424
317 <-> 1803
318 <-> 1491, 1556
319 <-> 982, 1533
320 <-> 224
321 <-> 401
322 <-> 890
323 <-> 1220, 1981
324 <-> 324, 1849
325 <-> 1153, 1206, 1573
326 <-> 1645
327 <-> 118, 857, 1064
328 <-> 703, 1100
329 <-> 1078, 1309
330 <-> 177
331 <-> 40, 1578, 1845
332 <-> 332, 1096
333 <-> 680, 1818, 1836
334 <-> 223
335 <-> 403
336 <-> 404, 1239, 1858
337 <-> 1406, 1610, 1788
338 <-> 1405
339 <-> 339
340 <-> 278, 693, 1261, 1313
341 <-> 816
342 <-> 342
343 <-> 164, 1569
344 <-> 449
345 <-> 772, 868
346 <-> 754, 1722
347 <-> 1073
348 <-> 1658, 1916
349 <-> 425, 725, 1757
350 <-> 380, 963
351 <-> 436, 507, 819, 966, 1603
352 <-> 1464
353 <-> 353, 1258
354 <-> 354, 797
355 <-> 1317
356 <-> 1620, 1807
357 <-> 648, 1202, 1708
358 <-> 1529, 1703
359 <-> 1305
360 <-> 124, 842
361 <-> 994, 1944
362 <-> 362
363 <-> 1221
364 <-> 238, 1146, 1176
365 <-> 509, 571
366 <-> 6, 711, 1655
367 <-> 137, 1953
368 <-> 109
369 <-> 369, 851, 863
370 <-> 81
371 <-> 310, 943
372 <-> 927
373 <-> 1953
374 <-> 1823, 1828
375 <-> 137, 1321
376 <-> 376, 526, 721, 1359
377 <-> 1647
378 <-> 378, 686
379 <-> 438, 651
380 <-> 350, 883
381 <-> 1171, 1772
382 <-> 453
383 <-> 1282
384 <-> 1300
385 <-> 1206, 1854
386 <-> 386
387 <-> 1962, 1978
388 <-> 772
389 <-> 622, 774, 1989
390 <-> 459
391 <-> 189, 688, 1351
392 <-> 715, 910
393 <-> 1924
394 <-> 47, 1564
395 <-> 272
396 <-> 396, 1672
397 <-> 1688
398 <-> 398, 1648
399 <-> 814
400 <-> 1987
401 <-> 321, 401
402 <-> 56, 470, 1564, 1701
403 <-> 310, 335
404 <-> 336, 841, 1051
405 <-> 936
406 <-> 935
407 <-> 294
408 <-> 1507
409 <-> 778
410 <-> 1247
411 <-> 1876, 1961, 1971
412 <-> 0
413 <-> 678, 1558
414 <-> 38, 1687
415 <-> 1474
416 <-> 124, 702, 1006
417 <-> 110, 307
418 <-> 418
419 <-> 1595
420 <-> 689, 713
421 <-> 1250, 1560
422 <-> 1498
423 <-> 186, 1824
424 <-> 496
425 <-> 349
426 <-> 602
427 <-> 493
428 <-> 981, 1393, 1616, 1909
429 <-> 1682
430 <-> 264, 877
431 <-> 1219, 1972
432 <-> 1682
433 <-> 1081, 1969
434 <-> 121, 468, 1744
435 <-> 1035, 1810
436 <-> 351
437 <-> 1950
438 <-> 379, 1955
439 <-> 439
440 <-> 841
441 <-> 1102, 1696
442 <-> 682, 1502
443 <-> 23, 1387
444 <-> 1662, 1802
445 <-> 1875
446 <-> 563
447 <-> 28
448 <-> 568, 963, 1850
449 <-> 344, 449
450 <-> 588, 1003
451 <-> 934, 1032
452 <-> 7
453 <-> 232, 382, 652, 1041, 1423, 1467
454 <-> 179, 752
455 <-> 1073, 1851
456 <-> 91, 174, 726, 1610
457 <-> 904, 1084, 1126
458 <-> 1377, 1470, 1646
459 <-> 390, 1244, 1478
460 <-> 509, 1780
461 <-> 1048, 1533
462 <-> 485, 1941
463 <-> 621, 1854
464 <-> 1013, 1091, 1343, 1973
465 <-> 1066
466 <-> 1007
467 <-> 299, 726
468 <-> 434
469 <-> 265, 1203
470 <-> 402, 701, 1453
471 <-> 753, 1085
472 <-> 775, 1483, 1651, 1695, 1761
473 <-> 514
474 <-> 29, 99, 1025, 1756
475 <-> 769, 799
476 <-> 504, 779
477 <-> 1310
478 <-> 302, 1939
479 <-> 950, 1278
480 <-> 0
481 <-> 1805
482 <-> 482, 1837
483 <-> 483
484 <-> 484
485 <-> 462, 485, 1293
486 <-> 509
487 <-> 175, 1124, 1772, 1884, 1919
488 <-> 1907
489 <-> 489
490 <-> 624, 1151
491 <-> 72, 579
492 <-> 492
493 <-> 212, 427, 853, 884
494 <-> 138, 1381, 1916
495 <-> 25, 944
496 <-> 424, 1749
497 <-> 793, 1767, 1942
498 <-> 199
499 <-> 281, 1177, 1917
500 <-> 1049
501 <-> 248
502 <-> 110, 676
503 <-> 1436, 1513
504 <-> 476
505 <-> 569, 1416
506 <-> 18, 301, 648
507 <-> 351, 881
508 <-> 95, 1313
509 <-> 365, 460, 486
510 <-> 604
511 <-> 1526
512 <-> 126, 1394, 1434
513 <-> 249, 951, 1809
514 <-> 473, 1106
515 <-> 148, 906, 1950
516 <-> 311, 1079
517 <-> 709
518 <-> 215, 1483
519 <-> 1451, 1692
520 <-> 816, 1937
521 <-> 521
522 <-> 935, 1154
523 <-> 971, 1197, 1737
524 <-> 285, 796, 1472
525 <-> 1001, 1033, 1756
526 <-> 376, 1736
527 <-> 1311, 1785
528 <-> 5, 204
529 <-> 1541, 1864, 1879
530 <-> 1052
531 <-> 647, 1890
532 <-> 780, 1597
533 <-> 1258
534 <-> 1231, 1963
535 <-> 1637
536 <-> 124
537 <-> 1633
538 <-> 538
539 <-> 843
540 <-> 242, 1522
541 <-> 1644
542 <-> 64, 254, 1623
543 <-> 580, 1484
544 <-> 1214, 1996
545 <-> 1959
546 <-> 260, 1765
547 <-> 1335
548 <-> 977
549 <-> 1384
550 <-> 901, 956
551 <-> 1681, 1830
552 <-> 29
553 <-> 1608
554 <-> 637
555 <-> 1743
556 <-> 1118, 1868
557 <-> 1278, 1289
558 <-> 994, 1095
559 <-> 1151, 1376
560 <-> 1224, 1758
561 <-> 1720
562 <-> 562
563 <-> 446, 563
564 <-> 1173, 1985
565 <-> 960, 1300, 1517
566 <-> 984, 1583
567 <-> 871, 1294, 1609
568 <-> 448, 1487
569 <-> 210, 505
570 <-> 888, 1042
571 <-> 365
572 <-> 26, 258, 572
573 <-> 913
574 <-> 1614
575 <-> 658, 1404
576 <-> 837
577 <-> 1060
578 <-> 693
579 <-> 491
580 <-> 543, 1192
581 <-> 928
582 <-> 943, 1494
583 <-> 1086, 1193, 1209
584 <-> 282, 835
585 <-> 1095
586 <-> 303
587 <-> 1726
588 <-> 450, 1430, 1797, 1881
589 <-> 133, 1231
590 <-> 1996
591 <-> 51, 1104
592 <-> 592
593 <-> 255, 821
594 <-> 1097, 1260
595 <-> 147, 198, 612, 1940
596 <-> 1150
597 <-> 77
598 <-> 674
599 <-> 1978
600 <-> 773, 1332
601 <-> 235
602 <-> 59, 312, 426, 1088, 1745
603 <-> 1031, 1898
604 <-> 510, 1062
605 <-> 1072
606 <-> 606, 672, 1072
607 <-> 1090, 1198, 1749
608 <-> 194, 217
609 <-> 609, 1121
610 <-> 1858
611 <-> 1351
612 <-> 188, 595, 679
613 <-> 1533
614 <-> 286, 1283, 1888
615 <-> 1225
616 <-> 616
617 <-> 93, 1566
618 <-> 1694
619 <-> 1674
620 <-> 131, 889, 1045, 1107
621 <-> 463, 1295
622 <-> 389
623 <-> 178
624 <-> 490, 1233, 1473
625 <-> 1601
626 <-> 766, 1515
627 <-> 1747
628 <-> 1176
629 <-> 840
630 <-> 284, 743
631 <-> 41, 143
632 <-> 239, 742
633 <-> 1265, 1792
634 <-> 634
635 <-> 811, 970
636 <-> 1207, 1568
637 <-> 159, 554, 978
638 <-> 665, 1699, 1822
639 <-> 980, 1442
640 <-> 65, 783, 1817
641 <-> 155, 287, 641, 1259
642 <-> 709, 745, 892, 1766, 1798
643 <-> 1998
644 <-> 1006, 1749
645 <-> 1179, 1274
646 <-> 1284
647 <-> 531, 647, 904
648 <-> 55, 357, 506, 1395
649 <-> 971, 1910
650 <-> 38
651 <-> 69, 227, 379, 1755
652 <-> 453, 1935
653 <-> 33
654 <-> 1630, 1887
655 <-> 1792
656 <-> 1504
657 <-> 1205, 1824
658 <-> 575
659 <-> 1805
660 <-> 299
661 <-> 924
662 <-> 47, 846
663 <-> 860, 1568
664 <-> 218
665 <-> 65, 638, 1208, 1287
666 <-> 37, 86, 1792
667 <-> 1176
668 <-> 1056
669 <-> 1453, 1933
670 <-> 235, 747, 1410
671 <-> 671, 1545
672 <-> 606, 1640
673 <-> 1615
674 <-> 598, 1727
675 <-> 102, 1560
676 <-> 502
677 <-> 1479
678 <-> 413, 1510
679 <-> 612, 1591, 1938
680 <-> 333, 1010, 1264, 1835
681 <-> 891
682 <-> 442, 1872
683 <-> 61, 933, 987
684 <-> 684, 867
685 <-> 1467
686 <-> 149, 378
687 <-> 1222
688 <-> 391, 1833
689 <-> 420, 829
690 <-> 1920, 1950
691 <-> 83, 1030
692 <-> 812
693 <-> 340, 578
694 <-> 760, 1197
695 <-> 849, 1946
696 <-> 696
697 <-> 244, 697, 859
698 <-> 246, 1398
699 <-> 1240, 1483
700 <-> 1652
701 <-> 7, 470, 1761
702 <-> 416, 1707
703 <-> 328, 1745
704 <-> 704, 811, 860
705 <-> 705
706 <-> 706, 1584
707 <-> 115, 904, 1523
708 <-> 1306
709 <-> 517, 642
710 <-> 75
711 <-> 366, 1932
712 <-> 233, 294, 1486
713 <-> 420
714 <-> 176, 929, 1103, 1748
715 <-> 392, 1800
716 <-> 824
717 <-> 1527, 1845
718 <-> 129
719 <-> 1824
720 <-> 213, 720
721 <-> 376
722 <-> 773, 1093, 1659
723 <-> 723
724 <-> 724, 999, 1831
725 <-> 349, 1965
726 <-> 456, 467
727 <-> 727, 1855
728 <-> 728
729 <-> 134
730 <-> 249
731 <-> 58
732 <-> 799, 1386
733 <-> 295
734 <-> 1976
735 <-> 735
736 <-> 170
737 <-> 1795
738 <-> 1852
739 <-> 1457, 1487, 1504
740 <-> 923
741 <-> 243, 1039
742 <-> 632
743 <-> 311, 630
744 <-> 1837
745 <-> 642
746 <-> 262, 1059, 1308
747 <-> 670, 1218
748 <-> 898
749 <-> 1904
750 <-> 1997
751 <-> 917, 990, 1588
752 <-> 454, 916
753 <-> 471
754 <-> 220, 346, 1661
755 <-> 1550
756 <-> 22, 1521
757 <-> 1540
758 <-> 862, 1575
759 <-> 759, 1118, 1561, 1966
760 <-> 694, 760
761 <-> 66
762 <-> 1080, 1817
763 <-> 763, 1872
764 <-> 817
765 <-> 765
766 <-> 626, 905
767 <-> 113, 856, 1563, 1905
768 <-> 1308, 1674
769 <-> 475, 1009, 1510
770 <-> 770
771 <-> 771, 1893
772 <-> 345, 388
773 <-> 600, 722
774 <-> 389, 990, 1254
775 <-> 472
776 <-> 1473
777 <-> 0
778 <-> 409, 854, 1244
779 <-> 52, 476, 1691, 1761
780 <-> 532
781 <-> 1631
782 <-> 67, 1043
783 <-> 640
784 <-> 896
785 <-> 269, 1383, 1992
786 <-> 1095
787 <-> 914, 975
788 <-> 1674
789 <-> 1593
790 <-> 113
791 <-> 1983
792 <-> 1136
793 <-> 13, 497, 995, 1738
794 <-> 310
795 <-> 810
796 <-> 524, 1342
797 <-> 354, 1713
798 <-> 1164
799 <-> 475, 732
800 <-> 46, 1448
801 <-> 830, 909, 1471, 1829
802 <-> 1019, 1509
803 <-> 62
804 <-> 1934
805 <-> 1052
806 <-> 1356, 1647
807 <-> 807
808 <-> 808
809 <-> 1130, 1895
810 <-> 795, 810, 1555
811 <-> 635, 704, 1417
812 <-> 692, 1831
813 <-> 1335, 1708
814 <-> 399, 873, 1256
815 <-> 1818
816 <-> 341, 520
817 <-> 764, 903
818 <-> 1061
819 <-> 351, 1077
820 <-> 1885
821 <-> 593
822 <-> 1590, 1679, 1757
823 <-> 1034, 1860
824 <-> 716, 1879
825 <-> 293, 1276, 1619, 1877
826 <-> 978
827 <-> 1778
828 <-> 1263, 1317
829 <-> 689, 1037, 1585
830 <-> 801
831 <-> 1551, 1998
832 <-> 104
833 <-> 1194, 1925
834 <-> 900, 1924
835 <-> 584
836 <-> 1196, 1679
837 <-> 576, 1253
838 <-> 1484, 1543
839 <-> 1904
840 <-> 31, 629, 1136, 1750
841 <-> 122, 404, 440
842 <-> 35, 360, 1859
843 <-> 539, 1303, 1368, 1639
844 <-> 1388
845 <-> 224, 1018, 1205, 1314
846 <-> 77, 662
847 <-> 1969
848 <-> 1437
849 <-> 695, 1698
850 <-> 850
851 <-> 229, 369
852 <-> 50
853 <-> 493, 895, 1951
854 <-> 778, 1243, 1385
855 <-> 855
856 <-> 34, 767
857 <-> 327, 1890
858 <-> 858, 1301
859 <-> 697, 1227, 1454
860 <-> 663, 704, 1076
861 <-> 87, 1721
862 <-> 758, 870
863 <-> 369, 911
864 <-> 224, 1000
865 <-> 110
866 <-> 1976
867 <-> 684
868 <-> 345, 1985
869 <-> 1058
870 <-> 862, 1867
871 <-> 567
872 <-> 43, 1173, 1369
873 <-> 814
874 <-> 158
875 <-> 1163, 1592
876 <-> 219
877 <-> 430, 1108
878 <-> 897, 1196
879 <-> 1475
880 <-> 78
881 <-> 507, 1842
882 <-> 44
883 <-> 380
884 <-> 493
885 <-> 263
886 <-> 183
887 <-> 1387
888 <-> 570, 1306
889 <-> 620
890 <-> 322, 1987
891 <-> 681, 1619
892 <-> 642, 1122, 1762
893 <-> 893
894 <-> 1163
895 <-> 853
896 <-> 247, 784, 1073, 1400
897 <-> 878
898 <-> 748, 919
899 <-> 194
900 <-> 834, 1298, 1412
901 <-> 550, 1187, 1476
902 <-> 902, 918
903 <-> 817, 1410
904 <-> 306, 457, 647, 707, 1942
905 <-> 200, 766
906 <-> 515
907 <-> 1440, 1680
908 <-> 1738
909 <-> 801
910 <-> 231, 392, 1690, 1890
911 <-> 863, 1215
912 <-> 9, 912
913 <-> 239, 573, 1058
914 <-> 787, 1098
915 <-> 922
916 <-> 752, 916
917 <-> 284, 751, 1149, 1221
918 <-> 902
919 <-> 208, 898, 1225, 1456
920 <-> 9, 27, 51
921 <-> 146, 921
922 <-> 53, 267, 915
923 <-> 22, 740, 1356
924 <-> 48, 661
925 <-> 1105, 1366
926 <-> 57, 1577
927 <-> 372, 1101, 1669, 1783
928 <-> 85, 581, 928, 949, 1490, 1801
929 <-> 714, 1463
930 <-> 122
931 <-> 1349
932 <-> 934
933 <-> 683
934 <-> 451, 932, 1986
935 <-> 406, 522, 1137, 1263
936 <-> 405, 1401, 1603, 1822
937 <-> 1321
938 <-> 1469
939 <-> 939
940 <-> 1111
941 <-> 109
942 <-> 942, 1637
943 <-> 371, 582
944 <-> 495, 1882
945 <-> 1634
946 <-> 125, 207, 946
947 <-> 947
948 <-> 1211
949 <-> 928
950 <-> 105, 479
951 <-> 513, 1491
952 <-> 952, 1199
953 <-> 42
954 <-> 1214, 1782
955 <-> 1241, 1772, 1970
956 <-> 550
957 <-> 291, 990
958 <-> 1785, 1856
959 <-> 968, 1186, 1559, 1827
960 <-> 565
961 <-> 124
962 <-> 1701
963 <-> 350, 448
964 <-> 74, 1066, 1452
965 <-> 64, 1342
966 <-> 351
967 <-> 1193, 1300, 1563
968 <-> 959
969 <-> 1824
970 <-> 635, 1636
971 <-> 523, 649
972 <-> 977, 1781, 1799
973 <-> 1735
974 <-> 224
975 <-> 178, 240, 787, 1440
976 <-> 1004
977 <-> 548, 972, 977, 1345
978 <-> 637, 826, 1307, 1508
979 <-> 1103
980 <-> 45, 639
981 <-> 428
982 <-> 145, 319
983 <-> 78, 184
984 <-> 566, 984
985 <-> 1573
986 <-> 296
987 <-> 683
988 <-> 988
989 <-> 1219, 1586
990 <-> 188, 751, 774, 957
991 <-> 1093, 1191, 1613
992 <-> 1531
993 <-> 1698
994 <-> 361, 558, 1339, 1903
995 <-> 98, 793
996 <-> 151, 1101, 1886
997 <-> 78
998 <-> 107
999 <-> 724, 1951
1000 <-> 864, 1058
1001 <-> 66, 525
1002 <-> 134
1003 <-> 289, 450, 1635
1004 <-> 976, 1340, 1452
1005 <-> 1178, 1776, 1881
1006 <-> 416, 644
1007 <-> 58, 466, 1375, 1835
1008 <-> 106, 148, 1524
1009 <-> 299, 769
1010 <-> 680, 1667
1011 <-> 1011
1012 <-> 63
1013 <-> 103, 464
1014 <-> 1134, 1779
1015 <-> 232
1016 <-> 1016
1017 <-> 1851
1018 <-> 100, 845, 1493
1019 <-> 802, 1604
1020 <-> 283
1021 <-> 1175, 1540, 1553
1022 <-> 225
1023 <-> 80, 1286, 1878
1024 <-> 1562
1025 <-> 474
1026 <-> 1026
1027 <-> 76, 1443, 1899
1028 <-> 259
1029 <-> 1798
1030 <-> 691
1031 <-> 199, 603, 1585, 1734
1032 <-> 451
1033 <-> 525, 1416
1034 <-> 823, 1117, 1657
1035 <-> 435, 1826
1036 <-> 1640
1037 <-> 829, 1654
1038 <-> 1692
1039 <-> 741, 1612, 1780
1040 <-> 220
1041 <-> 453
1042 <-> 291, 570
1043 <-> 782
1044 <-> 1044, 1508, 1897, 1930
1045 <-> 620, 1045, 1052
1046 <-> 265
1047 <-> 1565, 1718
1048 <-> 461
1049 <-> 500, 1827
1050 <-> 1050, 1729
1051 <-> 271, 404
1052 <-> 530, 805, 1045
1053 <-> 1335, 1642
1054 <-> 33, 1057
1055 <-> 1055
1056 <-> 186, 668, 1110, 1113
1057 <-> 160, 1054, 1278
1058 <-> 869, 913, 1000
1059 <-> 746
1060 <-> 577, 1124
1061 <-> 818, 1536, 1894
1062 <-> 118, 604
1063 <-> 1125
1064 <-> 327, 1318
1065 <-> 87, 1728
1066 <-> 465, 964, 1685
1067 <-> 1067, 1796
1068 <-> 262
1069 <-> 1304, 1632
1070 <-> 307, 314, 1906
1071 <-> 1650
1072 <-> 605, 606
1073 <-> 289, 347, 455, 896, 1132
1074 <-> 1245
1075 <-> 75
1076 <-> 237, 860
1077 <-> 819
1078 <-> 165, 329
1079 <-> 516
1080 <-> 762
1081 <-> 433, 1182
1082 <-> 140, 1597
1083 <-> 1977
1084 <-> 457
1085 <-> 471, 1933
1086 <-> 583, 1752, 1923
1087 <-> 1101
1088 <-> 120, 602
1089 <-> 29, 202, 1238
1090 <-> 607, 1773, 1982
1091 <-> 464, 1590, 1918
1092 <-> 1580, 1880
1093 <-> 722, 991
1094 <-> 146, 176
1095 <-> 558, 585, 786, 1217
1096 <-> 42, 332
1097 <-> 594
1098 <-> 165, 914
1099 <-> 1672
1100 <-> 328, 1998
1101 <-> 927, 996, 1087, 1234, 1994
1102 <-> 441, 1939
1103 <-> 714, 979, 1298
1104 <-> 591
1105 <-> 925
1106 <-> 514, 1697
1107 <-> 620, 1485
1108 <-> 877, 1108
1109 <-> 11, 1325, 1355, 1627, 1733
1110 <-> 1056, 1409, 1896
1111 <-> 940, 1210
1112 <-> 1112
1113 <-> 1056
1114 <-> 1291, 1595
1115 <-> 91
1116 <-> 1336
1117 <-> 1034, 1528
1118 <-> 556, 759
1119 <-> 1329
1120 <-> 81, 230
1121 <-> 609, 1326
1122 <-> 892
1123 <-> 1500
1124 <-> 487, 1060
1125 <-> 1063, 1230
1126 <-> 457
1127 <-> 27
1128 <-> 1763
1129 <-> 58, 216, 1642
1130 <-> 809
1131 <-> 127, 1189, 1353
1132 <-> 1073
1133 <-> 1685
1134 <-> 258, 1014, 1503
1135 <-> 136
1136 <-> 792, 840
1137 <-> 935
1138 <-> 130
1139 <-> 1505, 1915
1140 <-> 1759
1141 <-> 1141, 1937
1142 <-> 1539
1143 <-> 1640
1144 <-> 1144, 1468
1145 <-> 201, 1272, 1488
1146 <-> 4, 364
1147 <-> 1271, 1446
1148 <-> 6, 1593
1149 <-> 917
1150 <-> 596, 1760
1151 <-> 490, 559
1152 <-> 1530, 1834
1153 <-> 325, 1885
1154 <-> 522, 1620, 1770
1155 <-> 1417
1156 <-> 1380, 1397
1157 <-> 1829
1158 <-> 1158
1159 <-> 60, 1787
1160 <-> 1823
1161 <-> 1278, 1710, 1948
1162 <-> 1319, 1999
1163 <-> 875, 894
1164 <-> 798, 1902
1165 <-> 175
1166 <-> 1166
1167 <-> 92, 234
1168 <-> 1652
1169 <-> 57, 1358
1170 <-> 1334
1171 <-> 381
1172 <-> 36, 1449, 1661
1173 <-> 564, 872
1174 <-> 1884
1175 <-> 1021, 1717, 1759
1176 <-> 364, 628, 667, 1420, 1641
1177 <-> 499, 1374, 1405, 1931
1178 <-> 1005
1179 <-> 645
1180 <-> 1302, 1634
1181 <-> 1654
1182 <-> 1081, 1460, 1700
1183 <-> 145
1184 <-> 1975
1185 <-> 34
1186 <-> 959, 1790
1187 <-> 228, 901, 1628
1188 <-> 190, 1706
1189 <-> 1131
1190 <-> 253
1191 <-> 991
1192 <-> 580, 1429
1193 <-> 583, 967
1194 <-> 75, 833, 1214
1195 <-> 1445, 1454
1196 <-> 836, 878
1197 <-> 523, 694
1198 <-> 607
1199 <-> 952
1200 <-> 1624, 1840
1201 <-> 127, 1201, 1330
1202 <-> 357, 1404
1203 <-> 288, 469, 1461
1204 <-> 1559
1205 <-> 657, 845
1206 <-> 325, 385
1207 <-> 636, 1362, 1873
1208 <-> 665
1209 <-> 1, 583
1210 <-> 1111, 1669
1211 <-> 948, 1753
1212 <-> 1228
1213 <-> 1361, 1626
1214 <-> 544, 954, 1194, 1582
1215 <-> 911
1216 <-> 1765
1217 <-> 1095
1218 <-> 747, 1484
1219 <-> 270, 431, 989, 1465, 1475
1220 <-> 323, 1220
1221 <-> 363, 917
1222 <-> 122, 687, 1622
1223 <-> 1223
1224 <-> 31, 560
1225 <-> 615, 919
1226 <-> 1582, 1678
1227 <-> 859
1228 <-> 1212, 1357
1229 <-> 48
1230 <-> 1125, 1927
1231 <-> 184, 534, 589
1232 <-> 62
1233 <-> 624
1234 <-> 1101
1235 <-> 1235
1236 <-> 1236, 1424
1237 <-> 1984
1238 <-> 1089, 1829, 1980
1239 <-> 336, 1634
1240 <-> 699
1241 <-> 238, 297, 955
1242 <-> 273
1243 <-> 854, 1581, 1702
1244 <-> 459, 778, 1853
1245 <-> 267, 1074
1246 <-> 1850
1247 <-> 36, 410
1248 <-> 1489
1249 <-> 257, 1752
1250 <-> 421
1251 <-> 1630
1252 <-> 300, 1380, 1803
1253 <-> 837, 1464, 1901
1254 <-> 774
1255 <-> 1283
1256 <-> 814, 1771, 1821
1257 <-> 1276
1258 <-> 262, 353, 533, 1465
1259 <-> 641
1260 <-> 95, 594
1261 <-> 340
1262 <-> 1262
1263 <-> 828, 935
1264 <-> 259, 680
1265 <-> 633, 1666
1266 <-> 200
1267 <-> 198
1268 <-> 1965
1269 <-> 1805, 1851
1270 <-> 260, 1270
1271 <-> 1147
1272 <-> 1145, 1667
1273 <-> 1316
1274 <-> 44, 86, 152, 645, 1900
1275 <-> 132
1276 <-> 825, 1257
1277 <-> 1277
1278 <-> 479, 557, 1057, 1161
1279 <-> 1279
1280 <-> 1280, 1863
1281 <-> 1845
1282 <-> 12, 383, 1839
1283 <-> 614, 1255
1284 <-> 646, 1481
1285 <-> 1285
1286 <-> 163, 212, 1023
1287 <-> 665
1288 <-> 1288
1289 <-> 211, 557, 1991
1290 <-> 1919
1291 <-> 1114
1292 <-> 1817
1293 <-> 485, 1537, 1631
1294 <-> 567
1295 <-> 621
1296 <-> 1439, 1664
1297 <-> 16
1298 <-> 900, 1103
1299 <-> 1754
1300 <-> 384, 565, 967
1301 <-> 858, 1683, 1703
1302 <-> 1180, 1302
1303 <-> 843
1304 <-> 28, 264, 1069
1305 <-> 90, 359, 1385
1306 <-> 708, 888
1307 <-> 978, 1506, 1728
1308 <-> 746, 768
1309 <-> 329, 1715
1310 <-> 86, 477, 1634
1311 <-> 527, 1675
1312 <-> 81
1313 <-> 301, 340, 508
1314 <-> 845, 1314
1315 <-> 1531
1316 <-> 143, 199, 1273, 1379, 1684
1317 <-> 355, 828, 1635, 1697
1318 <-> 1064
1319 <-> 183, 1162, 1732, 1754
1320 <-> 1320
1321 <-> 375, 937, 1926
1322 <-> 1336
1323 <-> 1494, 1820
1324 <-> 1324
1325 <-> 166, 1109
1326 <-> 1121
1327 <-> 1753, 1993
1328 <-> 312, 1512
1329 <-> 1119, 1329
1330 <-> 1201
1331 <-> 1851
1332 <-> 600
1333 <-> 1376, 1869
1334 <-> 1170, 1859
1335 <-> 101, 547, 813, 1053
1336 <-> 1116, 1322, 1667
1337 <-> 268, 1946
1338 <-> 1514
1339 <-> 994, 1562
1340 <-> 1004, 1340, 1444
1341 <-> 1623
1342 <-> 796, 965, 1342
1343 <-> 464
1344 <-> 39
1345 <-> 977
1346 <-> 1609, 1802
1347 <-> 114, 162
1348 <-> 62, 1917
1349 <-> 931, 1349, 1963
1350 <-> 1350, 1378
1351 <-> 391, 611, 1351, 1985
1352 <-> 209, 1352
1353 <-> 1131
1354 <-> 249
1355 <-> 161, 1109, 1607
1356 <-> 806, 923, 1905, 1911
1357 <-> 1228, 1915
1358 <-> 1169
1359 <-> 376, 1815
1360 <-> 1631, 1914
1361 <-> 1213
1362 <-> 1207
1363 <-> 1733
1364 <-> 1596
1365 <-> 1763
1366 <-> 170, 925, 1750
1367 <-> 113
1368 <-> 102, 843
1369 <-> 872, 1959
1370 <-> 1370
1371 <-> 1371
1372 <-> 46
1373 <-> 1420
1374 <-> 1177, 1374
1375 <-> 1007
1376 <-> 559, 1333, 1977
1377 <-> 458, 1986
1378 <-> 1350
1379 <-> 1316
1380 <-> 244, 1156, 1252
1381 <-> 494
1382 <-> 1447
1383 <-> 785
1384 <-> 549, 1384
1385 <-> 200, 854, 1305
1386 <-> 732
1387 <-> 443, 887
1388 <-> 844, 1723, 1958
1389 <-> 272, 1914
1390 <-> 1487, 1806
1391 <-> 1523
1392 <-> 1746, 1872
1393 <-> 428
1394 <-> 512
1395 <-> 648
1396 <-> 92, 1537, 1663
1397 <-> 1156
1398 <-> 79, 698, 1433, 1497
1399 <-> 1399
1400 <-> 896
1401 <-> 936
1402 <-> 309
1403 <-> 1795, 1877
1404 <-> 575, 1202, 1741
1405 <-> 338, 1177
1406 <-> 337
1407 <-> 1824
1408 <-> 180, 1570, 1769
1409 <-> 1110
1410 <-> 670, 903
1411 <-> 75
1412 <-> 900
1413 <-> 15
1414 <-> 1545
1415 <-> 1415
1416 <-> 505, 1033
1417 <-> 225, 811, 1155
1418 <-> 1996
1419 <-> 192
1420 <-> 1176, 1373, 1489, 1577
1421 <-> 114, 252, 1928
1422 <-> 1995
1423 <-> 141, 453
1424 <-> 316, 1236
1425 <-> 1774, 1775
1426 <-> 214, 1437
1427 <-> 1901
1428 <-> 1990
1429 <-> 160, 1192
1430 <-> 588
1431 <-> 117, 241, 1818
1432 <-> 1432
1433 <-> 1398
1434 <-> 512
1435 <-> 1660
1436 <-> 503, 1436, 1952
1437 <-> 848, 1426
1438 <-> 1660, 1769
1439 <-> 221, 273, 1296
1440 <-> 907, 975
1441 <-> 1607
1442 <-> 47, 639
1443 <-> 183, 1027, 1915
1444 <-> 1340
1445 <-> 1195
1446 <-> 286, 1147, 1518
1447 <-> 1382, 1588
1448 <-> 800, 1480, 1891
1449 <-> 1172
1450 <-> 1450, 1811
1451 <-> 519, 1823
1452 <-> 964, 1004
1453 <-> 0, 470, 669
1454 <-> 859, 1195
1455 <-> 125, 1473
1456 <-> 919
1457 <-> 739, 1556
1458 <-> 90
1459 <-> 111, 1459
1460 <-> 205, 1182
1461 <-> 63, 119, 1203, 1461
1462 <-> 203, 1978
1463 <-> 929
1464 <-> 226, 352, 1253
1465 <-> 1219, 1258
1466 <-> 222
1467 <-> 453, 685, 1936
1468 <-> 1144, 1843
1469 <-> 938, 1469
1470 <-> 458
1471 <-> 801
1472 <-> 524
1473 <-> 624, 776, 1455
1474 <-> 415, 1716
1475 <-> 879, 1219, 1760
1476 <-> 901, 1476
1477 <-> 176
1478 <-> 459
1479 <-> 86, 187, 677
1480 <-> 1448, 1783
1481 <-> 1284, 1674
1482 <-> 1528, 1711
1483 <-> 472, 518, 699
1484 <-> 543, 838, 1218, 1645
1485 <-> 1107
1486 <-> 712, 1486, 1574
1487 <-> 568, 739, 1390
1488 <-> 1145, 1862
1489 <-> 1248, 1420
1490 <-> 928
1491 <-> 318, 951
1492 <-> 1492
1493 <-> 1018, 1856, 1907
1494 <-> 582, 1323, 1892
1495 <-> 1573
1496 <-> 184, 1846
1497 <-> 1398
1498 <-> 124, 232, 422
1499 <-> 214
1500 <-> 1123, 1747
1501 <-> 140, 1501
1502 <-> 442
1503 <-> 1134
1504 <-> 656, 739
1505 <-> 1139
1506 <-> 1307
1507 <-> 408, 1903
1508 <-> 978, 1044, 1512
1509 <-> 802, 1700
1510 <-> 678, 769, 1641, 1865
1511 <-> 266, 298, 1587
1512 <-> 153, 1328, 1508
1513 <-> 503, 1747, 1976
1514 <-> 1338, 1590
1515 <-> 626
1516 <-> 1519
1517 <-> 40, 565, 1743, 1787
1518 <-> 1446
1519 <-> 1516, 1519
1520 <-> 1538, 1599
1521 <-> 756, 1988, 1993
1522 <-> 540, 1644, 1669
1523 <-> 707, 1391
1524 <-> 1008
1525 <-> 1659
1526 <-> 20, 511, 1706
1527 <-> 717, 1598
1528 <-> 1117, 1482, 1528, 1596
1529 <-> 358
1530 <-> 1152, 1606
1531 <-> 90, 992, 1315, 1914
1532 <-> 1532
1533 <-> 222, 319, 461, 613, 1828
1534 <-> 150
1535 <-> 1535
1536 <-> 1061
1537 <-> 1293, 1396, 1652
1538 <-> 1520, 1538, 1789
1539 <-> 1142, 1681, 1689
1540 <-> 757, 1021
1541 <-> 529, 1554
1542 <-> 1639, 1784
1543 <-> 838
1544 <-> 1544
1545 <-> 671, 1414
1546 <-> 1577, 1709
1547 <-> 144, 232
1548 <-> 1548
1549 <-> 1727, 1783, 1871
1550 <-> 755, 1812
1551 <-> 831
1552 <-> 1552
1553 <-> 1021
1554 <-> 1541
1555 <-> 810
1556 <-> 318, 1457
1557 <-> 1557, 1625
1558 <-> 413, 1921
1559 <-> 959, 1204
1560 <-> 421, 675
1561 <-> 759, 1808
1562 <-> 1024, 1339
1563 <-> 767, 967
1564 <-> 394, 402
1565 <-> 1047, 1565
1566 <-> 180, 617, 1605
1567 <-> 1567
1568 <-> 636, 663
1569 <-> 343
1570 <-> 1408, 1705
1571 <-> 1688
1572 <-> 1908, 1929
1573 <-> 325, 985, 1495, 1769
1574 <-> 1486
1575 <-> 758
1576 <-> 230
1577 <-> 926, 1420, 1546
1578 <-> 331
1579 <-> 1697
1580 <-> 1092, 1881
1581 <-> 1243
1582 <-> 1214, 1226
1583 <-> 566
1584 <-> 706
1585 <-> 829, 1031
1586 <-> 196, 989, 1960
1587 <-> 1511, 1630, 1649
1588 <-> 88, 751, 1447
1589 <-> 98
1590 <-> 822, 1091, 1514, 1882
1591 <-> 679
1592 <-> 183, 875
1593 <-> 789, 1148
1594 <-> 1986
1595 <-> 87, 419, 1114
1596 <-> 1364, 1528
1597 <-> 532, 1082
1598 <-> 1527, 1633
1599 <-> 1520
1600 <-> 45
1601 <-> 625, 1652
1602 <-> 238
1603 <-> 83, 351, 936, 1605
1604 <-> 1019, 1944
1605 <-> 1566, 1603
1606 <-> 37, 1530
1607 <-> 1355, 1441, 1617
1608 <-> 553, 1608
1609 <-> 567, 1346
1610 <-> 337, 456
1611 <-> 1910
1612 <-> 283, 1039
1613 <-> 991
1614 <-> 2, 574, 1614
1615 <-> 673, 1827
1616 <-> 428
1617 <-> 1607, 1617
1618 <-> 1691, 1770
1619 <-> 146, 825, 891
1620 <-> 356, 1154
1621 <-> 1637
1622 <-> 96, 1222
1623 <-> 542, 1341
1624 <-> 1200, 1796
1625 <-> 1557
1626 <-> 1213, 1626
1627 <-> 1109
1628 <-> 1187
1629 <-> 58, 194
1630 <-> 654, 1251, 1587
1631 <-> 781, 1293, 1360
1632 <-> 1069
1633 <-> 537, 1598
1634 <-> 945, 1180, 1239, 1310
1635 <-> 1003, 1317
1636 <-> 164, 970
1637 <-> 535, 942, 1621
1638 <-> 1643
1639 <-> 843, 1542, 1753
1640 <-> 672, 1036, 1143
1641 <-> 1176, 1510
1642 <-> 1053, 1129
1643 <-> 1638, 1659
1644 <-> 541, 1522
1645 <-> 326, 1484
1646 <-> 458
1647 <-> 377, 806
1648 <-> 398
1649 <-> 1587
1650 <-> 1071, 1660
1651 <-> 472
1652 <-> 700, 1168, 1537, 1601
1653 <-> 313
1654 <-> 1037, 1181
1655 <-> 366
1656 <-> 303
1657 <-> 1034
1658 <-> 348
1659 <-> 58, 121, 722, 1525, 1643
1660 <-> 1435, 1438, 1650
1661 <-> 754, 1172, 1763, 1880
1662 <-> 444
1663 <-> 1396
1664 <-> 1296, 1888
1665 <-> 14, 1665
1666 <-> 1265
1667 <-> 1010, 1272, 1336
1668 <-> 1668
1669 <-> 927, 1210, 1522
1670 <-> 1971
1671 <-> 192, 1790
1672 <-> 396, 1099
1673 <-> 1906, 1950
1674 <-> 619, 768, 788, 1481
1675 <-> 1311
1676 <-> 36
1677 <-> 1677
1678 <-> 1226
1679 <-> 822, 836
1680 <-> 907
1681 <-> 551, 1539
1682 <-> 429, 432, 1924
1683 <-> 1301, 1848
1684 <-> 1316
1685 <-> 1066, 1133
1686 <-> 185, 1934
1687 <-> 414, 1750
1688 <-> 140, 397, 1571
1689 <-> 195, 1539, 1964
1690 <-> 910
1691 <-> 779, 1618, 1876
1692 <-> 519, 1038
1693 <-> 1693
1694 <-> 126, 618, 1694
1695 <-> 472
1696 <-> 441
1697 <-> 1106, 1317, 1579
1698 <-> 22, 274, 849, 993
1699 <-> 638
1700 <-> 1182, 1509
1701 <-> 402, 962
1702 <-> 53, 1243
1703 <-> 358, 1301
1704 <-> 150, 1889
1705 <-> 1570, 1826
1706 <-> 272, 1188, 1526
1707 <-> 195, 702
1708 <-> 357, 813
1709 <-> 19, 1546
1710 <-> 1161
1711 <-> 1482
1712 <-> 1712
1713 <-> 797
1714 <-> 115
1715 <-> 1309
1716 <-> 1474, 1909
1717 <-> 1175
1718 <-> 1047, 1809
1719 <-> 251
1720 <-> 62, 561
1721 <-> 861
1722 <-> 346
1723 <-> 1388, 1996
1724 <-> 304, 1828
1725 <-> 1988
1726 <-> 587, 1726
1727 <-> 674, 1549, 1857
1728 <-> 1065, 1307, 1821
1729 <-> 1050
1730 <-> 104, 1730
1731 <-> 1731, 1759
1732 <-> 1319, 1990
1733 <-> 1109, 1363
1734 <-> 1031
1735 <-> 973, 1735
1736 <-> 526
1737 <-> 523
1738 <-> 793, 908
1739 <-> 279
1740 <-> 1740
1741 <-> 1404
1742 <-> 1742
1743 <-> 555, 1517
1744 <-> 434
1745 <-> 602, 703
1746 <-> 1392
1747 <-> 627, 1500, 1513
1748 <-> 714
1749 <-> 496, 607, 644, 1943
1750 <-> 139, 244, 840, 1366, 1687
1751 <-> 50
1752 <-> 1086, 1249
1753 <-> 1211, 1327, 1639
1754 <-> 1299, 1319
1755 <-> 651
1756 <-> 474, 525
1757 <-> 349, 822
1758 <-> 560
1759 <-> 48, 1140, 1175, 1731
1760 <-> 1150, 1475
1761 <-> 472, 701, 779
1762 <-> 892
1763 <-> 1128, 1365, 1661
1764 <-> 1878
1765 <-> 546, 1216
1766 <-> 142, 642
1767 <-> 497
1768 <-> 1772
1769 <-> 1408, 1438, 1573
1770 <-> 1154, 1618
1771 <-> 1256
1772 <-> 381, 487, 955, 1768
1773 <-> 1090
1774 <-> 1425
1775 <-> 1425, 1902
1776 <-> 1005
1777 <-> 87
1778 <-> 256, 276, 827, 1780
1779 <-> 1014
1780 <-> 460, 1039, 1778
1781 <-> 972
1782 <-> 954
1783 <-> 279, 927, 1480, 1549, 1909
1784 <-> 1542
1785 <-> 527, 958
1786 <-> 1786
1787 <-> 1159, 1517
1788 <-> 337
1789 <-> 1538
1790 <-> 245, 1186, 1671, 1790
1791 <-> 246, 1925
1792 <-> 633, 655, 666, 1949
1793 <-> 1944
1794 <-> 156
1795 <-> 737, 1403
1796 <-> 296, 1067, 1624
1797 <-> 588
1798 <-> 642, 1029
1799 <-> 177, 972
1800 <-> 715
1801 <-> 928
1802 <-> 444, 1346, 1844, 1954
1803 <-> 317, 1252
1804 <-> 156
1805 <-> 481, 659, 1269
1806 <-> 1390
1807 <-> 356, 1939
1808 <-> 1561
1809 <-> 513, 1718
1810 <-> 435
1811 <-> 1450, 1874
1812 <-> 80, 1550
1813 <-> 67, 1813
1814 <-> 1814
1815 <-> 1359
1816 <-> 1816
1817 <-> 280, 640, 762, 1292
1818 <-> 333, 815, 1431
1819 <-> 241, 1974
1820 <-> 253, 1323
1821 <-> 1256, 1728
1822 <-> 638, 936
1823 <-> 374, 1160, 1451
1824 <-> 423, 657, 719, 969, 1407
1825 <-> 193
1826 <-> 1035, 1705
1827 <-> 70, 959, 1049, 1615
1828 <-> 374, 1533, 1724
1829 <-> 208, 801, 1157, 1238
1830 <-> 551, 1839
1831 <-> 724, 812
1832 <-> 1881, 1887
1833 <-> 688
1834 <-> 1152
1835 <-> 680, 1007
1836 <-> 333
1837 <-> 482, 744
1838 <-> 48, 1932
1839 <-> 32, 1282, 1830
1840 <-> 82, 1200
1841 <-> 260
1842 <-> 134, 141, 881
1843 <-> 1468
1844 <-> 1802
1845 <-> 257, 331, 717, 1281
1846 <-> 1496
1847 <-> 193, 258
1848 <-> 1683
1849 <-> 178, 324
1850 <-> 448, 1246
1851 <-> 455, 1017, 1269, 1331
1852 <-> 222, 738
1853 <-> 1244
1854 <-> 385, 463
1855 <-> 727
1856 <-> 958, 1493
1857 <-> 1727
1858 <-> 336, 610
1859 <-> 842, 1334
1860 <-> 172, 226, 823
1861 <-> 1861
1862 <-> 72, 1488
1863 <-> 1280
1864 <-> 529
1865 <-> 1510
1866 <-> 223, 1989
1867 <-> 870, 1939
1868 <-> 556
1869 <-> 1333
1870 <-> 1892
1871 <-> 1549
1872 <-> 682, 763, 1392
1873 <-> 1207
1874 <-> 173, 1811
1875 <-> 6, 150, 445
1876 <-> 411, 1691, 1956
1877 <-> 76, 89, 825, 1403
1878 <-> 295, 1023, 1764
1879 <-> 114, 529, 824
1880 <-> 1092, 1661
1881 <-> 588, 1005, 1580, 1832
1882 <-> 944, 1590
1883 <-> 244
1884 <-> 232, 487, 1174
1885 <-> 820, 1153
1886 <-> 996
1887 <-> 654, 1832, 1968
1888 <-> 614, 1664, 1888
1889 <-> 1704
1890 <-> 531, 857, 910
1891 <-> 1448, 1891
1892 <-> 1494, 1870
1893 <-> 771
1894 <-> 1061, 1894
1895 <-> 216, 809
1896 <-> 1110
1897 <-> 1044
1898 <-> 603
1899 <-> 1027
1900 <-> 167, 1274
1901 <-> 1253, 1427, 1986
1902 <-> 160, 1164, 1775
1903 <-> 994, 1507
1904 <-> 252, 749, 839
1905 <-> 130, 767, 1356
1906 <-> 1070, 1673
1907 <-> 488, 1493
1908 <-> 145, 1572
1909 <-> 428, 1716, 1783
1910 <-> 649, 1611
1911 <-> 1356
1912 <-> 96
1913 <-> 1913
1914 <-> 1360, 1389, 1531
1915 <-> 1139, 1357, 1443
1916 <-> 348, 494
1917 <-> 499, 1348
1918 <-> 1091
1919 <-> 487, 1290
1920 <-> 690
1921 <-> 1558
1922 <-> 237
1923 <-> 1086
1924 <-> 393, 834, 1682
1925 <-> 833, 1791
1926 <-> 1321
1927 <-> 1230, 1927
1928 <-> 1421, 1928
1929 <-> 1572, 1929
1930 <-> 1044
1931 <-> 112, 1177, 1995
1932 <-> 711, 1838
1933 <-> 669, 1085
1934 <-> 804, 1686
1935 <-> 652
1936 <-> 1467
1937 <-> 520, 1141
1938 <-> 679
1939 <-> 478, 1102, 1807, 1867
1940 <-> 595
1941 <-> 462
1942 <-> 497, 904
1943 <-> 1749
1944 <-> 361, 1604, 1793
1945 <-> 1945
1946 <-> 695, 1337
1947 <-> 204
1948 <-> 1161
1949 <-> 1792
1950 <-> 437, 515, 690, 1673
1951 <-> 853, 999
1952 <-> 1436
1953 <-> 367, 373, 1953
1954 <-> 176, 1802
1955 <-> 438
1956 <-> 135, 1876
1957 <-> 1957
1958 <-> 1388
1959 <-> 545, 1369
1960 <-> 123, 1586
1961 <-> 411
1962 <-> 387
1963 <-> 534, 1349
1964 <-> 1689
1965 <-> 725, 1268, 1965
1966 <-> 759
1967 <-> 111
1968 <-> 1887
1969 <-> 433, 847
1970 <-> 955
1971 <-> 309, 411, 1670
1972 <-> 431
1973 <-> 464
1974 <-> 1819
1975 <-> 7, 1184
1976 <-> 734, 866, 1513
1977 <-> 1083, 1376
1978 <-> 46, 387, 599, 1462
1979 <-> 82
1980 <-> 1238
1981 <-> 323
1982 <-> 1090
1983 <-> 197, 791
1984 <-> 1237, 1984
1985 <-> 564, 868, 1351
1986 <-> 934, 1377, 1594, 1901
1987 <-> 400, 890, 1987
1988 <-> 1521, 1725
1989 <-> 389, 1866
1990 <-> 315, 1428, 1732
1991 <-> 1289
1992 <-> 125, 158, 277, 785
1993 <-> 290, 1327, 1521
1994 <-> 275, 1101
1995 <-> 1422, 1931
1996 <-> 24, 544, 590, 1418, 1723
1997 <-> 750, 1997
1998 <-> 643, 831, 1100
1999 <-> 1162
GRAPHSPEC

puts connected(graph_spec, 0).length
puts groups(graph_spec).length
