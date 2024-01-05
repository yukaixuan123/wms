using Microsoft.EntityFrameworkCore;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore
{
    public class MyContext : DbContext
    {
        public MyContext(DbContextOptions<MyContext> options) : base(options)
        {
            //读取ui层的配置信息
        }
        //1 配置连接字符串
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
           // optionsBuilder.UseSqlServer("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;");

            optionsBuilder.LogTo(msg =>
            {
                if (!msg.Contains("CommandExecuting"))
                {
                    return;
                }
                Console.WriteLine(msg);

            });

        }
        //2 读取配置类
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
           
            //程序集
            modelBuilder.ApplyConfigurationsFromAssembly(GetType().Assembly);
            //modelBuilder.Entity<ST>(view =>
            //{
            //    view.HasNoKey(); // 告诉 Entity Framework 这是一个视图

            //    view.ToView("ST"); // 视图名称
        
            //});
            //modelBuilder.Entity<ST>().ToView("ST");
           
        }
        //3 根据实体类名创建操作对象
        //仓库
        public DbSet<Bs_warehouse> Bs_ware { get; set; }
        //仓位
        public DbSet<Bs_ware_area> bs_wa { get; set; }
        //入库管理
        public DbSet<Wh_inbill_h> Wh_hh { get; set; }
    
        public DbSet<Users> Users { get; set; }
        //货品类型
        public DbSet<Bs_item_type> bs_Item_Types { get; set; }
        //货品信息
        public DbSet<Bs_item> bs_Items { get; set; }
        //入库明细信息
        public DbSet<Wh_inbill_d> Wh_dd { get; set; }
        
        
        //进货详细信息
        public DbSet<Wh_orderbuy_d> Wh_orderbuy_d { get; set; }

        public DbSet<ST> st { get; set; }
        //用户
        public DbSet<Users> Users_Users { get; set; }
        //供应商
        public DbSet<Bs_supply> Bs_supply { get; set; }

        //用户
        public DbSet<Users> user { get; set; }

        public DbSet<Bs_supply> super { get; set; }

        //客户
        public DbSet<Bs_customer> Bs_customer { get; set; }
        //编码规则
        public DbSet<Sys_encode> Sys_encode { get; set; }
        //角色
        public DbSet<Roles> Roles { get; set; }
        //角色权限
        public DbSet<RolesAuthority> RolesAuthority { get; set; }
        //权限地址
        public DbSet<Authority> Authority { get; set; }



       
        //供应商视图
        public DbSet<SupplyView> supplyViews { get; set; }
        public DbSet<Bs_supply> bs_Supplies { get; set; }
        //客户视图
        public DbSet<CustomerView> customerViews { get; set; }
        public DbSet<Bs_customer> bs_Customer { get; set; }
        //库位管理
        public DbSet<Bs_ware_area> bs_Ware_Areas { get; set; }
        //仓库管理
        public DbSet<Bs_warehouse> bs_Warehouses { get; set; }
      
    }
}