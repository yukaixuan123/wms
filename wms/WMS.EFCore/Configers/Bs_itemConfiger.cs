using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Sup;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 货品表
    /// </summary>
    internal class Bs_itemConfiger : IEntityTypeConfiguration<Bs_item>
    {
        public void Configure(EntityTypeBuilder<Bs_item> builder)
        {
            builder.ToTable(nameof(Bs_item));
            builder.HasKey(e => e.item_id);
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.item_name).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.item_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sort_code).IsRequired();
            builder.Property(e => e.inbill_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.model_code).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.outbill_price).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.inbill_price).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.item_up).IsRequired();
            builder.Property(e => e.item_down).IsRequired();
            builder.Property(e => e.below_down).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.above_up).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.unit).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired();
        }
    }
}
