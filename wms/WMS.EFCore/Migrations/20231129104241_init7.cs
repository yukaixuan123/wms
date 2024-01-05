using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WMS.EFCore.Migrations
{
    /// <inheritdoc />
    public partial class init7 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "buy_goods_money",
                table: "Wh_orderbuy_d",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<string>(
                name: "is_del",
                table: "Wh_orderbuy_d",
                type: "char(1)",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "ware_name",
                table: "Wh_inbill_h",
                type: "varchar(50)",
                unicode: false,
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "char(10)",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "sure_date",
                table: "Wh_inbill_h",
                type: "datetime",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime");

            migrationBuilder.AddColumn<string>(
                name: "inbill_bh",
                table: "Wh_inbill_h",
                type: "char(8)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "remark",
                table: "Wh_inbill_d",
                type: "varchar(500)",
                unicode: false,
                maxLength: 500,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "is_del",
                table: "Users",
                type: "char(1)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ware_name",
                table: "Bs_warehouse",
                type: "varchar(50)",
                unicode: false,
                maxLength: 50,
                nullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "update_time",
                table: "Bs_ware_area",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "warehouse_id",
                table: "Bs_ware_area",
                type: "varchar(50)",
                unicode: false,
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "is_del",
                table: "Bs_supply",
                type: "char(1)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "st",
                columns: table => new
                {
                    inbill_code = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ware_name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    inbill_bh = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    inbill_type = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    inbill_state = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    inbll_date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    buy_code = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    sure_man = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    sure_date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    create_by = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    create_time = table.Column<DateTime>(type: "datetime2", nullable: false),
                    total_buy_num = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    total_price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    names = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    inbill_duty_man = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_st", x => x.inbill_code);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "st");

            migrationBuilder.DropColumn(
                name: "buy_goods_money",
                table: "Wh_orderbuy_d");

            migrationBuilder.DropColumn(
                name: "is_del",
                table: "Wh_orderbuy_d");

            migrationBuilder.DropColumn(
                name: "inbill_bh",
                table: "Wh_inbill_h");

            migrationBuilder.DropColumn(
                name: "remark",
                table: "Wh_inbill_d");

            migrationBuilder.DropColumn(
                name: "is_del",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "ware_name",
                table: "Bs_warehouse");

            migrationBuilder.DropColumn(
                name: "warehouse_id",
                table: "Bs_ware_area");

            migrationBuilder.DropColumn(
                name: "is_del",
                table: "Bs_supply");

            migrationBuilder.AlterColumn<string>(
                name: "ware_name",
                table: "Wh_inbill_h",
                type: "char(10)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "varchar(50)",
                oldUnicode: false,
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "sure_date",
                table: "Wh_inbill_h",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "update_time",
                table: "Bs_ware_area",
                type: "datetime",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime");
        }
    }
}
