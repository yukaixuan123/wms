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
    /// 调拨单表
    /// </summary>
    internal class Wh_transfer_hConfiger : IEntityTypeConfiguration<Wh_transfer_h>
    {
        public void Configure(EntityTypeBuilder<Wh_transfer_h> builder)
        {
            builder.ToTable(nameof(Wh_transfer_h));
            builder.HasKey(e => e.transfer_h_id);
            builder.Property(e => e.transfer_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.transfer_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.out_warecode).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.in_warecode).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.sure_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.transfer_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.outware_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.inware_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.sure_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_date).HasColumnType("datetime").IsRequired();
        }
    }
}
