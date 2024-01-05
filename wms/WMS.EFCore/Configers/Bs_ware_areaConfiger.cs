using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Bs;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 库位消息
    /// </summary>
    public class Bs_ware_areaConfiger : IEntityTypeConfiguration<Bs_ware_area>
    {
        public void Configure(EntityTypeBuilder<Bs_ware_area> builder)
        {
            builder.ToTable(nameof(Bs_ware_area));
            builder.HasKey(e => e.ware_area_id);
           
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.area_name).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.area_cap);
            builder.Property(e => e.area_duty_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sort_code);
            builder.Property(e => e.area_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.warehouse_id).HasMaxLength(50).IsUnicode(false).IsRequired(false);
        }
    }
}
