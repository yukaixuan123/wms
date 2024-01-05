using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 入库管理明细表
    /// </summary>
    internal class Wh_inbill_dConfiger : IEntityTypeConfiguration<Wh_inbill_d>
    {
        public void Configure(EntityTypeBuilder<Wh_inbill_d> builder)
        {
            builder.ToTable(nameof(Wh_inbill_d));
            builder.HasKey(e => e.inbill_id);
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.inbill_code).HasColumnType("char(8)").IsRequired();
           
            builder.Property(e => e.item_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.unit).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.buy_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.inbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.buy_price).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.product_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.batch_no).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.remark).HasMaxLength(500).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.zong).HasColumnType("decimal(18,2)").IsRequired();
        }
    }
}
