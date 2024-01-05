
using Microsoft.EntityFrameworkCore;
using WMS.AppService.AppService;
using WMS.AppService.AppService.Bs;
using WMS.AppService.AppService.Cm;
using WMS.AppService.AppService.Ku;
using WMS.AppService.AppService.Sup;
using WMS.AppService.AppService.Sys;
using WMS.AppService.AppService.Wh;
using WMS.AppService.Profiles;
using WMS.AppService.Profiles.Cm;
using WMS.AppService.Profiles.Ku;
using WMS.AppService.Profiles.Sys;
using WMS.AppService.Profiles.Wh;
using WMS.Domain.Repository;
using WMS.Domain.Repository.Bs;
using WMS.Domain.Repository.Cm;
using WMS.Domain.Repository.Ku;
using WMS.Domain.Repository.Sup;
using WMS.Domain.Repository.Sys;
using WMS.Domain.Repository.Wh;
using WMS.EFCore;
using WMS.EFCore.Repository;
using WMS.EFCore.Repository.Bs;
using WMS.EFCore.Repository.Cm;
using WMS.EFCore.Repository.Ku;
using WMS.EFCore.Repository.Sup;
using WMS.EFCore.Repository.Sys;
using WMS.EFCore.Repository.Wh;

namespace WMS
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            {
                //入库管理
                builder.Services.AddScoped<IWh_inbill_hAppService, Wh_inbill_hAppService>();
                builder.Services.AddScoped<IWh_inbill_hRepository, Wh_inbill_hRepository>();
                //货品类型
                builder.Services.AddScoped<IBs_itemtypeService, Bs_itemtypeService>();
                builder.Services.AddScoped<IBs_itemtypeRepository, Bs_itemtypeRepository>();
                //货品信息
                builder.Services.AddScoped<IBs_itemService, Bs_itemService>();
                builder.Services.AddScoped<IBs_itemRepository, Bs_itemRepository>();
                //仓库
                builder.Services.AddScoped<IBs_warehouseAppService, Bs_warehouseAppService>();
                builder.Services.AddScoped<IBs_warehouseRepository, Bs_warehouseRepository>();
                //库位
                builder.Services.AddScoped<IBs_ware_areaAppService, Bs_ware_areaAppService>();
                builder.Services.AddScoped<IBs_ware_areaRepository, Bs_ware_areaRepository>();

                //出库
                builder.Services.AddScoped<IWh_outbill_hAppService, Wh_outbill_hAppService>();
                builder.Services.AddScoped<IWh_outbill_hRepository, Wh_outbill_hRepository>();

                //盘点
                builder.Services.AddScoped<IWh_inventory_hAppService, Wh_inventory_hAppService>();
                builder.Services.AddScoped<IWh_inventory_hRepository, Wh_inventory_hRepository>();

                //调拨
                builder.Services.AddScoped<IWh_transfer_hAppService, Wh_transfer_hAppService>();
                builder.Services.AddScoped<IWh_transfer_hRepository, Wh_transfer_hRepository>();


                //进货订单
                builder.Services.AddScoped<IWh_buy_order_hAppService, Wh_buy_order_hAppService>();
                builder.Services.AddScoped<IWh_buy_order_hRepository, Wh_buy_order_hRepository>();
                //进货退货
                builder.Services.AddScoped<IWh_return_supply_hAppService, Wh_return_supply_hAppService>();
                builder.Services.AddScoped<IWh_return_supply_hRepository, Wh_return_supply_hRepository>();
                //销售订单
                builder.Services.AddScoped<IWh_sale_hAppService, Wh_sale_hAppService>();
                builder.Services.AddScoped<IWh_sale_hRepository, Wh_sale_hRepository>();
                //销售退货
                builder.Services.AddScoped<IWh_sale_return_hAppService, Wh_sale_return_hAppService>();
                builder.Services.AddScoped<IWh_sale_return_hRepository, Wh_sale_return_hRepository>();
                //首页
                builder.Services.AddScoped<IHomeAppService, HomeAppService>();
                builder.Services.AddScoped<IHomeRepository, HomeRepository>();


                builder.Services.AddScoped<IUsersAppService, UsersAppService>();
                builder.Services.AddScoped<IUsersRepository, UsersRepository>();

                //       
                builder.Services.AddScoped<ISys_encodeAppService, Sys_encodeAppService>();
                builder.Services.AddScoped<ISys_encodeRepository, Sys_encodeRepository>();

               
                builder.Services.AddScoped<IRolesAppService, RolesAppService>();
                builder.Services.AddScoped<IRolesRepository, RolesRepository>(); 
                //供应商
                builder.Services.AddScoped<ISupplyViewService, SupplyViewService>();
                builder.Services.AddScoped<ISupplyViewRepository, SupplyViewRepository>();
                //客户
                builder.Services.AddScoped<ICustomerViewService, CustomerViewService>();
                builder.Services.AddScoped<ICustomerViewRepository, CustomerViewRepository>();
            }
            {
                //注册配置类
                builder.Services.AddAutoMapper(typeof(Wh_inbill_hProfiles));
                builder.Services.AddAutoMapper(typeof(Bs_itemProfiles));
                builder.Services.AddAutoMapper(typeof(Bs_itemtypeProfiles));
                builder.Services.AddAutoMapper(typeof(UsersProfiles));
                builder.Services.AddAutoMapper(typeof(Sys_encodeProfiles));
                builder.Services.AddAutoMapper(typeof(RolesProfiles));
                builder.Services.AddAutoMapper(typeof(Wh_buy_order_hProfiles));
                builder.Services.AddAutoMapper(typeof(Wh_orderbuy_dProfiles));
            }
            builder.Services.AddDbContext<MyContext>(options =>
            {
                //读取连接字符串
                options.UseSqlServer(builder.Configuration.GetConnectionString("SqlConnection"));

                //全局取消实体状态跟踪
                options.UseQueryTrackingBehavior(QueryTrackingBehavior.NoTracking);
            });
            string[] urls = new[] { "http://localhost:8080" };
            builder.Services.AddCors(options =>
                options.AddDefaultPolicy(builder => builder.WithOrigins(urls)
                .AllowAnyMethod().AllowAnyHeader().AllowCredentials()));
            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            app.UseCors();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}