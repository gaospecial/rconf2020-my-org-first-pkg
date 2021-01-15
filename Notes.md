# rconf2020 教程：为你的团伙写一个 R 包

## 重要性

- 可能有一些通用的工作
- 提高工作效率

## 关键步骤

### 导入依赖的包和使用便利函数

- 推荐先使用 `use_package()` 导入包，然后使用 `pkg::fun()` 来调用包里面的函数；
- `usethis` 里面有一些函数帮助我们实现一些常用的功能，例如：`use_tibble()`, `use_data_table()`，`use_pipe()` 等。

### 编写函数文档

- `@param base_size` 改为 `@inheritParams ggplot2::theme_minimal` 时，函数参数的说明可以借；
- `@param ...` 后面可以使用 markdown 格式的方括号，如 "Additional arguments passed to [ggplot2::theme_minimal()]"
- `Cmd/Ctrl + Shift + D` 是 `document()` 的快捷键。`load_all()` 之后就可以查看刚刚编写的函数文档。
- 文档中的 `@export` 行指定函数是否对于用户可见。



### 测试包的功能

- `testthat` 包提供了可以让测试自动化的工具（`library(devtools)` 已经导入）；
- `use_test()` 可以创建一个新的测试函数；
  - 每个测试函数有一个标题；
  - 内部包括已知的结果，通过 `expect_*()` 函数来检验测试结果。
- 常见的测试函数有（详见[文档](https://r-pkgs.org/tests.html)）：
  - `expect_is()`，如：`expect_is(my_data, c("tbl_df","tbl","data.frame"))`；
  - `expect_gt()`，如：`expect_gt(nrow(resident_data), 0)`；
  - `expect_named()`，如：`expect_named(resident_data, c("sector", "residents"))`。
  - `expect_equal()`, `expect_identical()`
  - `expect_message/warning/error()`
  - `expect_output()`
  - `expect_match()`
- `test()` 将执行全部测试；`test_file()` 仅执行选定的测试；`check()` （`Cmd/Ctrl + Shift + E`）时会自动调用 `test()`。
- 在 `tests\testthat` 文件夹创建的 R 文件将在测试前执行，此处可以导入公用的数据；
- 每当解决一个 bug 后，写一个测试脚本确保万无一失。

### 为包写一个教程

- `use_vignette()` 来写一个教程，教程将随同包一起被分发；
- `use_readme_rmd()` 来写一个自我介绍。

### 捎带数据

- `use_data_raw()` 可以处理一些数据，然后记得 `source()` 这个 R 文件，以运行 `use_data()`。运行 `use_data()` 时，将会在 `data` 目录下面创建一个 `.rda` 文件保存数据。

- `use_rmarkdown_template()` 来创建一个 rmarkdown 模板。在 `inst/rmarkdown/templates/template-name` 下面创建一个 `skeleton` 文件夹和 `template.yaml` 文件。修改 `skeleton/skeleton.Rmd` 可以定义一个起始 rmarkdown 文档。

- 创建一个 usethis-style 的函数来帮助设置分析项目

  - 在 `inst/templates` 内创建 `pacakge.R`，`analysis.R` 和 `report.Rmd` 文件，在 `report.Rmd` 文件中，`title` 等设置使用 YAML 的变量（如`author: {{{author}}}`。这样，就可以通过函数参数改变 `report.Rmd` 的内容。

  - 创建一个 `R/create_analysis.R` 函数。这个函数将帮助设置分析项目的目录，导入通用的代码和数据，初始化一个 rmarkdown 文档等。函数定义如下：

  - ```
    #' Create a directory for standard AVALANCHE anlyses
    #'
    #' `create_analysis()` creates a project template that incudes `packages.R`,
    #' `analysis.R`, and `report.Rmd`.
    #'
    #' @param path The directory path
    #' @param folder The name of the new analysis project
    #' @param author The author's name
    #' @param title The title of the report
    #'
    #' @return invisibly, the path of the analysis directory
    #' @export
    #'
    #' @examples
    create_analysis <- function(path = ".", folder = "avalanche_analysis", author = "Author", title = "Untitled Analysis") {
      analysis_path <- fs::path(path, folder)
      if (fs::dir_exists(analysis_path)) fs::dir_delete(analysis_path)
    
      usethis::ui_done("Writing {usethis::ui_path(folder)}")
      fs::dir_create(analysis_path)
    
      use_avalanche_template("packages.R", folder = folder)
      use_avalanche_template("analysis.R", folder = folder)
      use_avalanche_template(
        "report.Rmd",
        folder = folder,
        data = list(author = author, title = title)
      )
    
      invisible(analysis_path)
    }
    
    use_avalanche_template <- function(template, folder, data = list()) {
      usethis::use_template(
        template = template,
        save_as = fs::path(folder, template),
        data = data,
        package = "avalanchr"
      )
    }
    ```

  - `use_avalanche_template()` 定义了一个通用函数，用来加载模板的内容。

  - 安装包之后，使用 `create_analysis()` 可以创建一个报告。

- 捎带一个 Shiny 服务

  - 同样在 `inst` 文件夹下面建立一个包含 Shiny 程序的文件夹；

  - 写一个运行 Shiny app 的函数 `use_r("launch_app")`，其作用就是找到 Shiny app 的位置并运行它。

  - ```
    #' Launch Reactor Data Shiny App
    #'
    #' @return a shiny app
    #' @export
    launch_app <- function() {
      app_dir <- system.file(
        "shinyapps",
        "shiny_reactor_report",
        package = "avalanchr",
        mustWork = TRUE
      )
      shiny::runApp(app_dir)
    }
    
    ```

  - 重新安装软件包，就可以了。

- `inst` 文件夹是你的世界。

- 免疫 Git：`git_vaccinate()`

- 创建 RStudio 插件：`use_addin()`（插件也是一个 Shiny app）

## 为你的的包加一点干货

前面已经介绍了创建一个包所需要的必要步骤。不过，它现在仍然是一个空架子而已。要想让你的包可用，还需要添加一些必要的功能和函数。

- 访问数据库；
- 添加函数实现一些常用的功能；
- 如何管理包？
- 标准报告。

### 使用数据库

- `DBI`, `dplyr` 和 `dbplyr` 对于数据库操作非常关键。

#### SQLite 数据库

- 最简单的数据库是一个保存在内存中的 `SQLite` 数据库。

  ```R
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")
  ```

- 使用 `copy_to()` 函数将数据保存在数据库中（*注意：这只是临时的，仅当前数据库链接可用*）

  ```R
  dplyr::copy_to(
    dest = con, 
    df = nycflights13::flights,
    name = "flights",
    temporary = FALSE
  )
  ```

- 为数据库创建一个引用后，可以像访问一个数据库那样访问数据库中的表（会有一些操作不适用于数据连接，如 `tail()`，`write_csv()` 等）。

  ```R
  flights_tbl <- dplyr::tbl(con, "flights")
  flights_tbl
  ```

- 像下面的管道操作会自动转变为 SQL 查询应用到数据库中（*非常聪明的设计，网络只需要传递指令而非数据*）。

  ```R
  flights_tbl %>%
    group_by(month) %>%
    summarize(avg_dep_delay = mean(dep_delay))
  ```

- 由于数据连接不能直接保存，所以要先进行转换（使用 `collect()`）。

  ```R
  dep_delay_summary %>%
    as_tibble() %>%
    readr::write_csv("dep_delay_summary.csv")
  ```

- `nrow()` 也不能直接应用于数据连接，要用 `tally()` 代替。

  ```r
  dep_delay_summary %>% dplyr::tally()
  ```

- 数据库连接可以通过 `show_query()` 转化为 SQL 查询。

  ```R
  dep_delay_summary %>% 
    dplyr::tally() %>%
    dplyr::show_query()
  ```

#### MySQL 数据库

为了连接一个 MySQL 数据库，需要设置数据库的名称、用户名、密码、主机地址和端口等信息，最好是将这些东西保存在环境变量中。

- 使用 `usethis::edit_r_envion()` 可以编辑你的环境变量。这个命令将会打开 `~/.Renviron` 文件。编辑文件，将下列内容写进去。

  - *注意*：设置环境变量后，需要重新启动 R 才会应用。

  ```bash
  DBNAME=intendo
  USERNAME=
  PASSWORD=
  HOST=intendo-db.csa7qlmguqrf.us-east-1.rds.amazonaws.com
  PORT=3306
  ```

- 现在可以使用这些变量来连接数据库了。

  - *注意*：这里使用 `RMariaDB` 来访问 MySQL 数据库

  ```R
  con <-
    DBI::dbConnect(
      drv = RMariaDB::MariaDB(),
      dbname = Sys.getenv("DBNAME"),
      username = Sys.getenv("USERNAME"),
      password = Sys.getenv("PASSWORD"),
      host = Sys.getenv("HOST"),
      port = Sys.getenv("PORT")
    )
  ```

  - 如果出现 10061 错误，说明 MySQL 数据库不允许远程连接，需要修改 `/etc/mysql/my.cnf` 文件中：

  ```
  bind-address = 0.0.0.0
  ```

- 连接成功后，查看数据表

  ```R
  DBI::dbListTables(con)
  ```


### 做好函数的顶层设计

- 好的顶层设计包括：

  - 函数名选的好。如`org_connect()`, `org_report()`, `org_process_data()` 这些都是好名字，而像 `org_create_cal()` 则不然；
  - 函数能够分门别类。例如将所有函数划分为 3 个大类，数据存取、数据处理、生成报表等。
  - 函数抽象做的好。为实现一些通用的功能，创建一些 **helper** 函数，有利于简化代码逻辑。
  - *当然，你不必（也不可能）从一开始就有一个完整的顶层设计*。

- 对于一个游戏公司来说，最重要的数据包括：

  - DAU（Daily active users），日活用户；
  - MAU（Monthly active users），月活；
  - DAC（Daily active customers），日消费者；
  - ARPU（Average revenue per user），（一定时期内的）单位用户平均消费额。
  - 访问数据库并计算上述指标。

- 具体计算方法

  - DAU：给定一个日期，计算当日唯一的用户数目。计算 DAU 时，使用了 `vapply()` 函数，这个函数与 `sapply()` 类似，不过可以指定返回值的格式，更加安全和快；

    ```r
    get_dau <- function(con, dates) {
    
      dau_vals <-
        vapply(
          dates,
          FUN.VALUE = numeric(1),
          USE.NAMES = FALSE,
          FUN = function(date) {
            tbl_daily_users(con = con) %>%
              dplyr::mutate(date = as.Date(time)) %>%
              dplyr::filter(date == {{ date }}) %>%
              dplyr::select(user_id) %>%
              dplyr::distinct() %>%
              dplyr::summarize(n = dplyr::n()) %>%
              dplyr::collect() %>%
              dplyr::mutate(n = as.numeric(n)) %>%
              dplyr::pull(n)
          })
    
      mean(dau_vals, na.rm = TRUE)
    }
    ```

    

  - MAU：给定一个年月，查询当月所有的用户数。需要注意的是日期函数的应用。

    ```r
    year <- 2015
    month <- 2
    begin <- make_date(year = year, month = month, day = 1L)
    stop <- make_date(year = year, month = month + 1, day = 1L)
    daily_users %>%
      filter(time > begin, time < stop) %>%
      select(user_id) %>%
      distinct() %>%
      count() %>%
      pull(n)
    ```

  - DAC：在 DAU 基础上过滤一下即可；
  - ARPU：先算出给定时间内的总消费额，再除以 DAU 即可。

- 上述计算，仅仅接受时间作为参数，这在实际应用中是不够的。现实中，可能需要计算付费的日活（`is_customer == TRUE`），在线时长超过 1h 的日活（`total_time > 1`），消费超过 1 元的日活（`total_revenue > 1`）等等情况。

## 包的管理

做好包的管理，可以借助于 GitHub 的系统，充分利用 News，Git Tags，issues 等功能。当然，写一个 README 介绍包的亮点也很关键。此外，还可以使用 `pkgdown` 来创建一个示例网站（只需两步）。

```R
usethis::use_pkgdown()
pkgdown::build_site()
```

将生成一个 `docs` 文件夹。

- 下面是一个 `_pkgdown.yml` 文档的示例。

  ```yaml
  destination: docs
  
  home:
    strip_header: true
  
  reference:
    - title: Connect the DB
      desc: >
        We can get a connection for the Intendo MySQL database with either of two
        functions: `db_con()` or `db_con_p()`. Make sure you have credentials info
        available as environment variables.
      contents:
      - db_con
      - db_con_p
  
    - title: Access to DB tables
      desc: >
        There are three tables in the database, and, three functions that work
        to get us a `tbl_dbi` object from each.
      contents:
      - tbl_functions
  
    - title: Getting KPIs
      desc: >
        We can get KPIs with specialized functions for each. This makes it easy
        to get reporting information quickly. The KPIs currently supported are:
        `get_dau()`, `get_mau()`, `get_dac()`, and `get_arpu()`. With the
        `segment_daily_users()` function, we can create segmented versions of
        DAU.
      contents:
      - get_dau
      - get_mau
      - get_dac
      - get_arpu
      - segment_daily_users
  
    - title: Standardized Reporting
      desc: >
        With the `create_standard_ts_plot()` and `create_stanard_kpi_table()`
        functions, we have a means to generate a standardized ggplot and gt table.
        This is useful for reporting purposes and, for that reason, an R Markdown
        template is provided with these functions in a data processing chunk.
      contents:
      - create_standard_ts_plot
      - create_stanard_kpi_table
  
  development:
    mode: devel
  
  ```

  有了这些配置，将会生成一个非常优秀的 `pkgdown` 介绍页面。

  ![image-20210115234814975](https://vnote-1251564393.cos.ap-chengdu.myqcloud.com/typora-img/image-20210115234814975.png)

## 生成报告

报告由图和表构成，图由 `ggplot2` 负责，表格则可以由 `gt` 负责。

日常的报表，不妨放一个 `rmarkdown` 模板到 `inst` 文件夹中。

## 结语

为了给团伙写一个 R 包，需求、设计、代码（算法）、文档、教程等因素都得考虑在内，这是一个需要不断迭代完善的长期任务。