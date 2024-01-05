using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 出库管理明细表
    /// </summary>
    internal class Wh_outbill_dConfiger : IEntityTypeConfiguration<Wh_outbill_d>
    {
        public void Configure(EntityTypeBuilder<Wh_outbill_d> builder)
        {
            builder.ToTable(nameof(Wh_outbill_d));
            builder.HasKey(e => e.outbill_d_id);
            builder.Property(e => e.outbill_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.item_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.unit).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sale_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.outbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.sale_price).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.product_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.barcode).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
        }
    }
}
