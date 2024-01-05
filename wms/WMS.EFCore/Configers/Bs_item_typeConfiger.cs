using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Cm;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 货品类型
    /// </summary>
    internal class Bs_item_typeConfiger : IEntityTypeConfiguration<Bs_item_type>
    {
        public void Configure(EntityTypeBuilder<Bs_item_type> builder)
        {
            builder.ToTable(nameof(Bs_item_type));
            builder.HasKey(e => e.item_type_id);
            builder.Property(e => e.item_type_code).HasColumnType("char(8)").IsRequired();
            builder.Property(e => e.item_type_name).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.father_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.sort_code).IsRequired();
            builder.Property(e => e.inbill_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.remark).HasMaxLength(500).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
        }
    }
}
