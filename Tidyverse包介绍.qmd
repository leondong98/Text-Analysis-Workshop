---
title: Tidyverse 包介绍

---

# Tidyverse 包介绍

讲座人：Hanxu hanxu.dong.21@ucl.ac.uk


在本课程模块中，我们将使用多个来自 “Tidyverse” 的程序包 —— 这是一个为简化 R 中数据管理、处理与可视化而开发的数据科学套件集合。我们将从安装 Tidyverse 并加载它开始：

```r
install.packages("tidyverse") # 只需安装一次！如果你已经安装了 Tidyverse 软件包，则无需再次运行此行。
library(tidyverse) # 每当你想使用本页描述的功能时，都需要运行这一行代码
```

```
── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.4     ✔ readr     2.1.5
✔ forcats   1.0.0     ✔ stringr   1.5.1
✔ ggplot2   3.5.1     ✔ tibble    3.2.1
✔ lubridate 1.9.4     ✔ tidyr     1.3.1
✔ purrr     1.0.2     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

为了说明的目的，我们将在本页中使用 ``mtcars`` 数据集。``mtcars`` 是 R 中的一个内置数据集，包含了关于 32 种不同汽车模型的信息。它包含 11 个变量，例如燃油效率（``mpg``）、发动机排量（``disp``）以及汽缸数量（``cyl``）等。

由于其简单性以及包含多种数值和分类变量，``mtcars`` 数据集常被用于教授讲解基础的数据操作、编程和可视化。不过它本身非常无聊，在此表示歉意（我们将在课程中处理非常有趣的数据集！）

## 1. ``%>%`` (The Pipe Operator)

管道操作符 ``%>%`` 是 ``Tidyverse`` 中最重要的工具之一。它允许你将一个函数的输出直接传递给下一个函数作为输入，从而使代码更加简洁且易读。


### 举个例子

```r
# 如果没有 %>%
summarise(group_by(mtcars, cyl), avg_mpg = mean(mpg))
```

```
# A tibble: 3 × 2
    cyl avg_mpg
  <dbl>   <dbl>
1     4    26.7
2     6    19.7
3     8    15.1
```

```r
# 有了 %>%
mtcars %>%
  group_by(cyl) %>%
  summarise(avg_mpg = mean(mpg))
```

```
# A tibble: 3 × 2
    cyl avg_mpg
  <dbl>   <dbl>
1     4    26.7
2     6    19.7
3     8    15.1
```


## 2. ``dplyr`` 

``dplyr`` 包提供了一系列用于数据操作的函数。以下是一些你将经常使用的核心函数：

### ``filter()``
用 ``filter()`` 根据条件筛选数据框中的行:

```r
mtcars %>%
  filter(cyl == 4)  # 选择 'cyl' 为 4 的行
```

```
                mpg cyl  disp  hp drat    wt  qsec vs am gear carb
Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
Toyota Corona  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```


### ``select()``
使用 ``select()`` 选择特定的列:

```r
mtcars %>%
  select(mpg, cyl, gear)  # 只选择 'mpg', 'cyl', and 'gear' 列
```

```
                     mpg cyl gear
Mazda RX4           21.0   6    4
Mazda RX4 Wag       21.0   6    4
Datsun 710          22.8   4    4
Hornet 4 Drive      21.4   6    3
Hornet Sportabout   18.7   8    3
Valiant             18.1   6    3
Duster 360          14.3   8    3
Merc 240D           24.4   4    4
Merc 230            22.8   4    4
Merc 280            19.2   6    4
Merc 280C           17.8   6    4
Merc 450SE          16.4   8    3
Merc 450SL          17.3   8    3
Merc 450SLC         15.2   8    3
Cadillac Fleetwood  10.4   8    3
Lincoln Continental 10.4   8    3
Chrysler Imperial   14.7   8    3
Fiat 128            32.4   4    4
Honda Civic         30.4   4    4
Toyota Corolla      33.9   4    4
Toyota Corona       21.5   4    3
Dodge Challenger    15.5   8    3
AMC Javelin         15.2   8    3
Camaro Z28          13.3   8    3
Pontiac Firebird    19.2   8    3
Fiat X1-9           27.3   4    4
Porsche 914-2       26.0   4    5
Lotus Europa        30.4   4    5
Ford Pantera L      15.8   8    5
Ferrari Dino        19.7   6    5
Maserati Bora       15.0   8    5
Volvo 142E          21.4   4    4
```

### ``group_by()``
使用 ``group_by()`` 按一个或多个变量对数据进行分组，以便进行聚合操作:

```r
mtcars %>%
  group_by(cyl)  # 按汽缸(cylinders)数量进行分组
```

```
# A tibble: 32 × 11
# Groups:   cyl [3]
     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
 1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
 2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
 3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
 4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
 5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
 6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
 7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
 8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
 9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
# ℹ 22 more rows
```

### ``summarise()``
使用聚合函数如 ``mean()``、``sum()`` 或 ``n()`` 对数据进行汇总:

```r
mtcars %>%
  group_by(cyl) %>%
  summarise(avg_mpg = mean(mpg))  # 计算每个气缸组的 'mpg' 平均值
```

```
# A tibble: 3 × 2
    cyl avg_mpg
  <dbl>   <dbl>
1     4    26.7
2     6    19.7
3     8    15.1
```

### ``mutate()``
使用 ``mutate()`` 添加新列或转换已有列:

```r
mtcars %>%
  mutate(weight_kg = wt * 453.592)  # 将 '重量' 从 1000 磅转换为千克
```

```
                     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
                    weight_kg
Mazda RX4           1188.4110
Mazda RX4 Wag       1304.0770
Datsun 710          1052.3334
Hornet 4 Drive      1458.2983
Hornet Sportabout   1560.3565
Valiant             1569.4283
Duster 360          1619.3234
Merc 240D           1446.9585
Merc 230            1428.8148
Merc 280            1560.3565
Merc 280C           1560.3565
Merc 450SE          1846.1194
Merc 450SL          1691.8982
Merc 450SLC         1714.5778
Cadillac Fleetwood  2381.3580
Lincoln Continental 2460.2830
Chrysler Imperial   2424.4492
Fiat 128             997.9024
Honda Civic          732.5511
Toyota Corolla       832.3413
Toyota Corona       1118.1043
Dodge Challenger    1596.6438
AMC Javelin         1558.0885
Camaro Z28          1741.7933
Pontiac Firebird    1744.0612
Fiat X1-9            877.7005
Porsche 914-2        970.6869
Lotus Europa         686.2847
Ford Pantera L      1437.8866
Ferrari Dino        1256.4498
Maserati Bora       1619.3234
Volvo 142E          1260.9858
```


### ``pivot_longer()`` 和 ``pivot_wider()``
在长格式（long）和宽格式（wide）之间转换数据：

```r
# Example: pivot_longer
data <- tibble(id = 1:3, a = c(10, 20, 30), b = c(40, 50, 60))
data %>%
  pivot_longer(cols = a:b, names_to = "variable", values_to = "value")
```

```
# A tibble: 6 × 3
     id variable value
  <int> <chr>    <dbl>
1     1 a           10
2     1 b           40
3     2 a           20
4     2 b           50
5     3 a           30
6     3 b           60
```


```r
# Example: pivot_wider
data_long <- tibble(id = c(1, 1, 2, 2), variable = c("a", "b", "a", "b"), value = c(10, 40, 20, 50))
data_long %>%
  pivot_wider(names_from = variable, values_from = value)
```

```
# A tibble: 2 × 3
     id     a     b
  <dbl> <dbl> <dbl>
1     1    10    40
2     2    20    50
```


## 3. 连接（join）

``dplyr`` 提供了按行匹配合并数据集的函数。常见的连接（join）类型包括：

### ``full_join`` 
包括两个数据集中的所有行:

```r
df1 <- tibble(id = 1:3, value = c("A", "B", "C"))
df2 <- tibble(id = 2:4, value2 = c("X", "Y", "Z"))
full_join(df1, df2, by = "id")
```

```
# A tibble: 4 × 3
     id value value2
  <int> <chr> <chr> 
1     1 A     <NA>  
2     2 B     X     
3     3 C     Y     
4     4 <NA>  Z 
```


### ``right_join`` 
包括第二个数据集中的所有行和第一个数据集中的匹配行:

```r
right_join(df1, df2, by = "id")
```

```
# A tibble: 3 × 3
     id value value2
  <int> <chr> <chr> 
1     2 B     X     
2     3 C     Y     
3     4 <NA>  Z  
```

### ``left_join`` 
包括第一个数据集中的所有行和第二个数据集中的匹配行:

```r
left_join(df1, df2, by = "id")
```

```
# A tibble: 3 × 3
     id value value2
  <int> <chr> <chr> 
1     1 A     <NA>  
2     2 B     X     
3     3 C     Y   
```


### ``ggplot2`` 
``ggplot2`` 是 ``Tidyverse`` 中用于数据可视化的主要工具, 它允许你创建具有图层结构且可高度自定义的图形:

**示例：基本散点图**

```r
mtcars %>%
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "Scatter Plot of Weight vs MPG",
       x = "Weight (1000 lbs)",
       y = "Miles per Gallon")
```
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/td_1.png" width="800"/>


**示例：分组条形图**

```r
mtcars %>%
  group_by(cyl) %>%
  summarise(avg_mpg = mean(mpg)) %>%
  ggplot(aes(x = factor(cyl), y = avg_mpg)) +
  geom_bar(stat = "identity") +
  labs(title = "Average MPG by Cylinder",
       x = "Cylinders",
       y = "Average MPG")
```
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/td_2.png" width="800"/>



---

这并不是 ``Tidyverse`` 的完整教程！我会在课程中尽量解释所用函数，但如果你希望更深入学习 ``Tidyverse``，以下资源可能会对你有所帮助：

## 官方的 Tidyverse 介绍

- Tidyverse Packages Overview: https://www.tidyverse.org
一个集中展示所有 Tidyverse 包、其文档与更新的核心平台。
  
- dplyr Documentation: https://dplyr.tidyverse.org
了解更多关于数据操作函数的信息，如 ``filter()``、``mutate()`` 和 ``group_by()``。

- ggplot2 Documentation: https://ggplot2.tidyverse.org
浏览详细的可视化函数参考资料，深入探索图形创建方法。


