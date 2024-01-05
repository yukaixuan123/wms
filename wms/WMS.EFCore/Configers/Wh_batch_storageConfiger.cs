using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Pc;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 批次库存表
    /// </summary>
    internal class Wh_batch_storageConfiger : IEntityTypeConfiguration<Wh_batch_storage>
    {
        public void Configure(EntityTypeBuilder<Wh_batch_storage> builder)
        {
            builder.ToTable(nameof(Wh_batch_storage));
            builder.HasKey(e => e.batch_storage_id);
            builder.Property(e => e.ware_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired();
            builder.Property(e => e.inbill_type).HasColumnType("char(10)").IsRequired();
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.unit).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.inbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.outbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.plan_outbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.buy_price).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.product_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.batch_no).HasMaxLength(30).IsUnicode(false).IsRequired(false);
           
        }
    }
}
