using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WMS.EFCore.Migrations
{
    /// <inheritdoc />
    public partial class init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Authority",
                columns: table => new
                {
                    AuthorityID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AuthorityName = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    GroupID = table.Column<int>(type: "int", nullable: false),
                    AuthorityAddress = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Pid = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Authority", x => x.AuthorityID);
                });

            migrationBuilder.CreateTable(
                name: "Bs_customer",
                columns: table => new
                {
                    customer_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    cust_code = table.Column<string>(type: "char(8)", nullable: false),
                    cust_name = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_tel = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    e_mail = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    cust_adr = table.Column<string>(type: "varchar(225)", unicode: false, maxLength: 225, nullable: true),
                    inbill_state = table.Column<string>(type: "char(1)", nullable: true),
                    cust_from = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    is_del = table.Column<string>(type: "char(1)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_customer", x => x.customer_id);
                });

            migrationBuilder.CreateTable(
                name: "Bs_finance",
                columns: table => new
                {
                    finance_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    finance_name = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    tax_no = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    bank_no = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    open_bank = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    open_adr = table.Column<string>(type: "varchar(225)", unicode: false, maxLength: 225, nullable: true),
                    finance_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_finance", x => x.finance_id);
                });

            migrationBuilder.CreateTable(
                name: "Bs_item",
                columns: table => new
                {
                    item_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    item_code = table.Column<string>(type: "char(8)", nullable: false),
                    item_name = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    item_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    sort_code = table.Column<int>(type: "int", nullable: false),
                    inbill_state = table.Column<string>(type: "char(1)", nullable: true),
                    model_code = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    outbill_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    inbill_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    item_up = table.Column<int>(type: "int", nullable: false),
                    item_down = table.Column<int>(type: "int", nullable: false),
                    below_down = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    above_up = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    unit = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    is_del = table.Column<string>(type: "char(1)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_item", x => x.item_id);
                });

            migrationBuilder.CreateTable(
                name: "Bs_item_type",
                columns: table => new
                {
                    item_type_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    item_type_code = table.Column<string>(type: "char(8)", nullable: false),
                    item_type_name = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    father_code = table.Column<string>(type: "char(8)", nullable: true),
                    sort_code = table.Column<int>(type: "int", nullable: false),
                    inbill_state = table.Column<string>(type: "char(1)", nullable: true),
                    remark = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    is_del = table.Column<string>(type: "char(1)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_item_type", x => x.item_type_id);
                });

            migrationBuilder.CreateTable(
                name: "Bs_supply",
                columns: table => new
                {
                    supply_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    supply_code = table.Column<string>(type: "char(9)", nullable: false),
                    supply_name = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    line_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    supply_type_code = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_tel = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    e_mail = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    stock_duty_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    inbill_state = table.Column<string>(type: "char(1)", nullable: true),
                    supply_adr = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_supply", x => x.supply_id);
                });

            migrationBuilder.CreateTable(
                name: "Bs_ware_area",
                columns: table => new
                {
                    ware_area_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    area_code = table.Column<string>(type: "char(6)", nullable: true),
                    area_name = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    area_cap = table.Column<int>(type: "int", nullable: false),
                    area_duty_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sort_code = table.Column<int>(type: "int", nullable: false),
                    area_state = table.Column<string>(type: "char(1)", nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    is_del = table.Column<string>(type: "char(1)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_ware_area", x => x.ware_area_id);
                });

            migrationBuilder.CreateTable(
                name: "Bs_warehouse",
                columns: table => new
                {
                    warehouse_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ware_code = table.Column<string>(type: "char(8)", nullable: false),
                    ware_code3 = table.Column<string>(type: "char(6)", nullable: true),
                    ware_cap = table.Column<int>(type: "int", nullable: false),
                    ware_state = table.Column<string>(type: "char(1)", nullable: true),
                    ware_adr = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    is_default = table.Column<string>(type: "char(1)", nullable: true),
                    is_lock = table.Column<int>(type: "int", nullable: false),
                    ware_duty_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sort_code = table.Column<int>(type: "int", nullable: false),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    is_del = table.Column<string>(type: "char(1)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Bs_warehouse", x => x.warehouse_id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RolesID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RolesName = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    RolesAuthority = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    RolesState = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.RolesID);
                });

            migrationBuilder.CreateTable(
                name: "RolesAuthority",
                columns: table => new
                {
                    RolesAuthorityID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RolesID = table.Column<int>(type: "int", nullable: false),
                    AuthorityID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RolesAuthority", x => x.RolesAuthorityID);
                });

            migrationBuilder.CreateTable(
                name: "Sys_attach_file",
                columns: table => new
                {
                    saf_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    bill_code = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: false),
                    file_id = table.Column<int>(type: "int", nullable: false),
                    file_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    file_url = table.Column<string>(type: "varchar(225)", unicode: false, maxLength: 225, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sys_attach_file", x => x.saf_id);
                });

            migrationBuilder.CreateTable(
                name: "Sys_dict_data",
                columns: table => new
                {
                    dict_code = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    dict_name = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    dict_label = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    dict_type = table.Column<string>(type: "char(1)", nullable: true),
                    is_default = table.Column<string>(type: "char(1)", nullable: true),
                    status = table.Column<string>(type: "char(1)", nullable: true),
                    dict_value = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    remark = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sys_dict_data", x => x.dict_code);
                });

            migrationBuilder.CreateTable(
                name: "Sys_dict_type",
                columns: table => new
                {
                    dict_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    dict_name = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    dict_label = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    dict_value = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    remark = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sys_dict_type", x => x.dict_id);
                });

            migrationBuilder.CreateTable(
                name: "Sys_encode",
                columns: table => new
                {
                    en_step = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    en_code = table.Column<int>(type: "int", nullable: false),
                    en_form = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    en_prefix = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    en_time = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    en_num = table.Column<int>(type: "int", nullable: false),
                    en_rules = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    is_del = table.Column<string>(type: "char(1)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sys_encode", x => x.en_step);
                });

            migrationBuilder.CreateTable(
                name: "Sys_message",
                columns: table => new
                {
                    msg_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    msg_content = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true),
                    msg_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    msg_state = table.Column<string>(type: "char(1)", nullable: true),
                    send_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    send_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    rcv_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    rcv_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    is_read = table.Column<string>(type: "char(1)", nullable: true),
                    deal_url = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sys_message", x => x.msg_id);
                });

            migrationBuilder.CreateTable(
                name: "Sys_wh_warn",
                columns: table => new
                {
                    warn_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    warn_day = table.Column<int>(type: "int", nullable: false),
                    notice_man = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    warn_time = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sys_wh_warn", x => x.warn_id);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    UserRolesID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    RolesID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => x.UserRolesID);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    U_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    U_name = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    U_True_name = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    U_password = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    U_State = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.U_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_batch_storage",
                columns: table => new
                {
                    batch_storage_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ware_code = table.Column<string>(type: "char(8)", nullable: false),
                    area_code = table.Column<string>(type: "char(6)", nullable: false),
                    inbill_type = table.Column<string>(type: "char(10)", nullable: false),
                    item_code = table.Column<string>(type: "char(8)", nullable: false),
                    unit = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    inbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    outbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    plan_outbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    buy_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    product_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    batch_no = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_batch_storage", x => x.batch_storage_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_buy_order_h",
                columns: table => new
                {
                    buy_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    buy_code = table.Column<string>(type: "char(16)", nullable: false),
                    buy_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    supply_code = table.Column<string>(type: "char(9)", nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_way = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    buy_man = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_state = table.Column<string>(type: "char(1)", nullable: true),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    remark = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_buy_order_h", x => x.buy_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_inbill_d",
                columns: table => new
                {
                    inbill_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    item_code = table.Column<string>(type: "char(8)", nullable: false),
                    inbill_code = table.Column<int>(type: "int", nullable: false),
                    item_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    unit = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    buy_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    inbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    area_code = table.Column<string>(type: "char(6)", nullable: true),
                    buy_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    product_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    batch_no = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_inbill_d", x => x.inbill_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_inbill_h",
                columns: table => new
                {
                    inbill_code = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    inbill_type = table.Column<string>(type: "char(10)", nullable: true),
                    inbill_state = table.Column<string>(type: "char(1)", nullable: true),
                    inbll_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    buy_code = table.Column<string>(type: "char(16)", nullable: true),
                    supply_code = table.Column<string>(type: "char(9)", nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_way = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    inbill_duty_man = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    remark = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_state = table.Column<string>(type: "char(1)", nullable: true),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_inbill_h", x => x.inbill_code);
                });

            migrationBuilder.CreateTable(
                name: "Wh_inventory_d",
                columns: table => new
                {
                    inventory_d_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    inventory_code = table.Column<string>(type: "char(16)", nullable: false),
                    item_code = table.Column<string>(type: "char(8)", nullable: true),
                    model_code = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    unit = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    item_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    account_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    area_code = table.Column<string>(type: "char(6)", nullable: true),
                    inventory_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    break_even_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    inventory_state = table.Column<string>(type: "char(1)", nullable: true),
                    inbill_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    remark = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_inventory_d", x => x.inventory_d_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_inventory_h",
                columns: table => new
                {
                    inventory_h_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    inventory_code = table.Column<string>(type: "char(16)", nullable: false),
                    inventory_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    ware_code = table.Column<string>(type: "char(8)", nullable: true),
                    begin_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    end_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    sure_state = table.Column<string>(type: "char(1)", nullable: true),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_inventory_h", x => x.inventory_h_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_now_storage",
                columns: table => new
                {
                    ware_code = table.Column<string>(type: "char(8)", nullable: false),
                    now_storage_id = table.Column<int>(type: "int", nullable: false),
                    area_code = table.Column<string>(type: "char(6)", nullable: true),
                    item_code = table.Column<string>(type: "char(8)", nullable: true),
                    inbill3_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    plan_outnum = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_now_storage", x => x.ware_code);
                });

            migrationBuilder.CreateTable(
                name: "Wh_orderbuy_d",
                columns: table => new
                {
                    buy_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    buy_code = table.Column<string>(type: "char(16)", nullable: false),
                    item_name = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    item_code = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    model_code = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    unit = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    item_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    buy_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    inbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    return_goods_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_orderbuy_d", x => x.buy_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_outbill_d",
                columns: table => new
                {
                    outbill_d_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    outbill_code = table.Column<string>(type: "char(16)", nullable: false),
                    item_code = table.Column<string>(type: "char(8)", nullable: true),
                    item_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    unit = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    sale_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    outbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    area_code = table.Column<string>(type: "char(6)", nullable: true),
                    sale_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    batch_no = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    product_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    barcode = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_outbill_d", x => x.outbill_d_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_outbill_h",
                columns: table => new
                {
                    outbill_h_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    outbill_code = table.Column<string>(type: "char(16)", nullable: false),
                    outbill_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    outbill_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    sale_code = table.Column<string>(type: "char(16)", nullable: true),
                    cust_code = table.Column<string>(type: "char(8)", nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_way = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    duty_man = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    ware_code = table.Column<string>(type: "varchar(8)", unicode: false, maxLength: 8, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    sure_state = table.Column<string>(type: "char(1)", nullable: true),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_outbill_h", x => x.outbill_h_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_return_supply_d",
                columns: table => new
                {
                    item_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    item_code = table.Column<string>(type: "char(6)", nullable: false),
                    return_goods_num = table.Column<decimal>(type: "decimal(18,2)", maxLength: 18, nullable: false),
                    buy_price = table.Column<decimal>(type: "decimal(18,2)", maxLength: 18, nullable: false),
                    return_money = table.Column<decimal>(type: "decimal(18,2)", maxLength: 18, nullable: false),
                    batch_no = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: false),
                    model_code = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_return_supply_d", x => x.item_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_return_supply_h",
                columns: table => new
                {
                    buy_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    buy_code = table.Column<string>(type: "char(16)", nullable: false),
                    sale_state = table.Column<string>(type: "char(1)", nullable: true),
                    sr_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    supply_code = table.Column<string>(type: "char(9)", nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_way = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    buy_man = table.Column<string>(type: "varchar(80)", unicode: false, maxLength: 80, nullable: true),
                    returns_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    returns_money = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    buy_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    remark = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true),
                    create_by = table.Column<string>(type: "varchar(500)", unicode: false, maxLength: 500, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    update_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_state = table.Column<string>(type: "char(1)", nullable: true),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_return_supply_h", x => x.buy_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_sale_d",
                columns: table => new
                {
                    sale_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    sale_code = table.Column<string>(type: "char(16)", nullable: false),
                    item_code = table.Column<string>(type: "char(8)", nullable: true),
                    model_code = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    unit = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    item_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    inbill3_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    return_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    outbill_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    sale_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_sale_d", x => x.sale_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_sale_h",
                columns: table => new
                {
                    sale_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    sale_code = table.Column<string>(type: "char(16)", nullable: false),
                    sale_state = table.Column<string>(type: "char(1)", nullable: true),
                    sale_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    cust_code = table.Column<string>(type: "char(8)", nullable: true),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_way = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    sale_duty_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_sale_h", x => x.sale_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_sale_return_d",
                columns: table => new
                {
                    sr_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    sr_code = table.Column<string>(type: "char(16)", nullable: false),
                    item_code = table.Column<string>(type: "char(8)", nullable: true),
                    inbill3_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    return_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    ware_code = table.Column<string>(type: "char(8)", nullable: true),
                    area_code = table.Column<string>(type: "char(6)", nullable: true),
                    batch_no = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    sale_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_sale_return_d", x => x.sr_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_sale_return_h",
                columns: table => new
                {
                    sr_codeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    sr_code = table.Column<string>(type: "char(16)", nullable: false),
                    sr_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    sale_code = table.Column<string>(type: "char(16)", nullable: false),
                    cust_code = table.Column<string>(type: "char(8)", nullable: false),
                    link_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    link_way = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: true),
                    sale_duty_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    sure_state = table.Column<string>(type: "char(1)", nullable: false),
                    return_money = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_sale_return_h", x => x.sr_codeId);
                });

            migrationBuilder.CreateTable(
                name: "Wh_transfer_d",
                columns: table => new
                {
                    transfer_d_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    transfer_code = table.Column<string>(type: "char(16)", nullable: false),
                    wh__transfer_code = table.Column<string>(type: "char(16)", nullable: true),
                    item_code = table.Column<string>(type: "char(8)", nullable: true),
                    model_code = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    unit = table.Column<string>(type: "varchar(30)", unicode: false, maxLength: 30, nullable: true),
                    outarea_code = table.Column<string>(type: "char(6)", nullable: true),
                    inarea_code = table.Column<string>(type: "char(6)", nullable: true),
                    out_num = table.Column<int>(type: "int", nullable: false),
                    in_num = table.Column<int>(type: "int", nullable: false),
                    inbill_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_transfer_d", x => x.transfer_d_id);
                });

            migrationBuilder.CreateTable(
                name: "Wh_transfer_h",
                columns: table => new
                {
                    transfer_h_id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    transfer_code = table.Column<string>(type: "char(16)", nullable: false),
                    transfer_date = table.Column<DateTime>(type: "datetime", nullable: false),
                    out_warecode = table.Column<string>(type: "char(8)", nullable: true),
                    in_warecode = table.Column<string>(type: "char(8)", nullable: true),
                    sure_state = table.Column<string>(type: "char(1)", nullable: true),
                    transfer_type = table.Column<string>(type: "varchar(10)", unicode: false, maxLength: 10, nullable: true),
                    outware_state = table.Column<string>(type: "char(1)", nullable: true),
                    inware_state = table.Column<string>(type: "char(1)", nullable: true),
                    create_by = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    create_time = table.Column<DateTime>(type: "datetime", nullable: false),
                    sure_man = table.Column<string>(type: "varchar(64)", unicode: false, maxLength: 64, nullable: true),
                    sure_date = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Wh_transfer_h", x => x.transfer_h_id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Authority");

            migrationBuilder.DropTable(
                name: "Bs_customer");

            migrationBuilder.DropTable(
                name: "Bs_finance");

            migrationBuilder.DropTable(
                name: "Bs_item");

            migrationBuilder.DropTable(
                name: "Bs_item_type");

            migrationBuilder.DropTable(
                name: "Bs_supply");

            migrationBuilder.DropTable(
                name: "Bs_ware_area");

            migrationBuilder.DropTable(
                name: "Bs_warehouse");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "RolesAuthority");

            migrationBuilder.DropTable(
                name: "Sys_attach_file");

            migrationBuilder.DropTable(
                name: "Sys_dict_data");

            migrationBuilder.DropTable(
                name: "Sys_dict_type");

            migrationBuilder.DropTable(
                name: "Sys_encode");

            migrationBuilder.DropTable(
                name: "Sys_message");

            migrationBuilder.DropTable(
                name: "Sys_wh_warn");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Wh_batch_storage");

            migrationBuilder.DropTable(
                name: "Wh_buy_order_h");

            migrationBuilder.DropTable(
                name: "Wh_inbill_d");

            migrationBuilder.DropTable(
                name: "Wh_inbill_h");

            migrationBuilder.DropTable(
                name: "Wh_inventory_d");

            migrationBuilder.DropTable(
                name: "Wh_inventory_h");

            migrationBuilder.DropTable(
                name: "Wh_now_storage");

            migrationBuilder.DropTable(
                name: "Wh_orderbuy_d");

            migrationBuilder.DropTable(
                name: "Wh_outbill_d");

            migrationBuilder.DropTable(
                name: "Wh_outbill_h");

            migrationBuilder.DropTable(
                name: "Wh_return_supply_d");

            migrationBuilder.DropTable(
                name: "Wh_return_supply_h");

            migrationBuilder.DropTable(
                name: "Wh_sale_d");

            migrationBuilder.DropTable(
                name: "Wh_sale_h");

            migrationBuilder.DropTable(
                name: "Wh_sale_return_d");

            migrationBuilder.DropTable(
                name: "Wh_sale_return_h");

            migrationBuilder.DropTable(
                name: "Wh_transfer_d");

            migrationBuilder.DropTable(
                name: "Wh_transfer_h");
        }
    }
}
