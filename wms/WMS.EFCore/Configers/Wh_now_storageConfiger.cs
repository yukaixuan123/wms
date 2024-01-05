using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 库存表
    /// </summary>
    internal class Wh_now_storageConfiger : IEntityTypeConfiguration<Wh_now_storage>
    {
        public void Configure(EntityTypeBuilder<Wh_now_storage> builder)
        {
            builder.ToTable(nameof(Wh_now_storage));
            builder.HasKey(e => e.ware_code);
            builder.Property(e => e.ware_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.inbill3_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.plan_outnum).HasColumnType("decimal(18,2)").IsRequired();
        }
    }
}
