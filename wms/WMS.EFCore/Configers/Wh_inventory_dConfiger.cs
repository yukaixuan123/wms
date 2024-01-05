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
    /// 盘点明细表
    /// </summary>
    internal class Wh_inventory_dConfiger : IEntityTypeConfiguration<Wh_inventory_d>
    {
        public void Configure(EntityTypeBuilder<Wh_inventory_d> builder)
        {
            builder.ToTable(nameof(Wh_inventory_d));
            builder.HasKey(e => e.inventory_d_id);
            builder.Property(e => e.inventory_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.model_code).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.unit).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.item_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.account_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.inventory_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.break_even_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.inventory_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.inbill_price).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.remark).HasMaxLength(500).IsUnicode(false).IsRequired(false);
        }
    }
}
