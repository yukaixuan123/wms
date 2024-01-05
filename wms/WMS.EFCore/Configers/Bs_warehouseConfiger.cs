using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Sup;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 仓库
    /// </summary>
    public class Bs_warehouseConfiger : IEntityTypeConfiguration<Bs_warehouse>
    {
        public void Configure(EntityTypeBuilder<Bs_warehouse> builder)
        {
            builder.ToTable(nameof(Bs_warehouse));
            
                builder.HasKey(e => e.warehouse_id);
           
            builder.Property(e => e.ware_code).HasColumnType("char(8)").IsRequired();
           
            builder.Property(e => e.ware_code3).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.is_default).HasColumnType("char(1)").IsRequired(false);
            
                 builder.Property(e => e.is_lock);
            builder.Property(e => e.ware_adr).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.ware_cap);
            builder.Property(e => e.ware_duty_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sort_code);
            builder.Property(e => e.ware_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.ware_name).HasMaxLength(50).IsUnicode(false).IsRequired(false);
        }
    }
}
