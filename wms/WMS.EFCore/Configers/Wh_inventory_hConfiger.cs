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
    /// 盘点单表
    /// </summary>
    internal class Wh_inventory_hConfiger : IEntityTypeConfiguration<Wh_inventory_h>
    {
        public void Configure(EntityTypeBuilder<Wh_inventory_h> builder)
        {
            builder.ToTable(nameof(Wh_inventory_h));
            builder.HasKey(e => e.inventory_h_id);
            builder.Property(e => e.inventory_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.inventory_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.ware_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.begin_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.end_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.sure_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.sure_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_date).HasColumnType("datetime");
        }
    }
}
